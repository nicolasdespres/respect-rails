module Respect
  module Rails
    class ResponseSchemaSet

      class << self
        def each_response_file(controller_name, action_name, &block)
          glob = "#{::Rails.root}/app/schemas/#{controller_name}/#{action_name}-*.schema"
          Pathname.glob(glob).each do |path|
            if path.basename.to_s =~ /^#{action_name}-(.*?)\.schema$/
              status = $1.to_sym
              block.call(path, status)
            else
              raise "should never ever happens"
            end
          end
          ok_file = Pathname.new("#{::Rails.root}/app/schemas/#{controller_name}/#{action_name}.schema")
          if ok_file.exist?
            block.call(ok_file, :ok)
          end
        end
      end

      # Initialize a new ResponseSchemaSet object for the given controller's
      # action and collect response' schema from their respective file.
      def initialize(controller_name, action_name)
        @controller_name = controller_name
        @action_name = action_name
        @set = {}
        collect_from_files
      end

      attr_reader :controller_name, :action_name

      def method_missing(method_name, *arguments, &block)
        self << ResponseSchema.define(method_name.to_sym, *arguments, &block)
      end

      def [](http_status)
        @set[http_status]
      end

      def each_response_file(&block)
        self.class.each_response_file(@controller_name, @action_name, &block)
      end

      delegate :each, to: :@set

      def <<(response_schema)
        @set[response_schema.http_status] = response_schema
      end

      private

      def collect_from_files
        each_response_file do |path, status|
          self << ResponseSchema.define(status) do |r|
            r.instance_eval(path.read, path.to_s)
          end
        end
      end

    end
  end # module Rails
end # module Respect
