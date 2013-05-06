module Respect
  module Rails
    class RequestDef

      class << self
        def eval(*args, &block)
          new(*args).eval(&block)
        end
      end

      def initialize(*args)
        @request_schema = RequestSchema.new(*args)
      end

      def eval(&block)
        block.call(self)
        @request_schema
      end

      def path_parameters(&block)
        @request_schema.path_parameters = ObjectSchema.define(&block)
      end

      def request_parameters(&block)
        @request_schema.request_parameters = ObjectSchema.define(&block)
      end

    end # class RequestDef
  end
end # module Respect
