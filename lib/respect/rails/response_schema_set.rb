module Respect
  module Rails
    class ResponseSchemaSet

      class << self
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
      end

      attr_reader :controller_name, :action_name

      def method_missing(method_name, *arguments, &block)
        define_response(method_name, *arguments, &block)
      end

      def [](http_status)
        @set[http_status]
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
        self << ResponseSchema.define(status, *arguments, &block)
      end

    end
  end # module Rails
end # module Respect
