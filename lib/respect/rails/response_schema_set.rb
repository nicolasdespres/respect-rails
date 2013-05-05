module Respect
  module Rails
    class ResponseSchemaSet

      # FIXME(Nicolas Despres): Factor all file related code. This code should belongs to
      # ResponseSchema as other way to define it.

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

        # FIXME(Nicolas Despres): Move me to another module/class.
        def symbolize_status(status)
          case status
          when Symbol
            status
          when String
            if status =~ /^\d+$/
              symbolize_status(status.to_i)
            else
              status.to_sym
            end
          when Numeric
            ResponseSchema.symbolize_http_status(status.to_i)
          else
            raise ArgumentError, "cannot normalize status '#{status}:#{status.class}'"
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
        define_response(method_name, *arguments, &block)
      end

      def [](http_status)
        @set[http_status]
      end

      def each_response_file(&block)
        self.class.each_response_file(@controller_name, @action_name, &block)
      end

      delegate :each, :empty?, to: :@set

      def <<(response_schema)
        @set[response_schema.http_status] = response_schema
      end

      def is(status, *arguments, &block)
        define_response(status, *arguments, &block)
      end

      def define_response(status, *arguments, &block)
        status = self.class.symbolize_status(status)
        if block
          self << ResponseSchema.define(status, *arguments, &block)
        else
          filenames = [ "#{::Rails.root}/app/schemas/#@controller_name/#@action_name-#{status}.schema" ]
          if status == :ok
            filenames << "#{::Rails.root}/app/schemas/#@controller_name/#@action_name.schema"
          end
          filenames.each do |filename|
            if File.exists?(filename)
              self << ResponseSchema.from_file(status, filename)
              break
            end
          end
        end
      end

      private

      def collect_from_files
        each_response_file do |path, status|
          self << ResponseSchema.from_file(status, path.to_s)
        end
      end

    end
  end # module Rails
end # module Respect
