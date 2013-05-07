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
        @request_schema.path_parameters = HashSchema.define(&block)
      end

      def body_parameters(&block)
        @request_schema.body_parameters = HashSchema.define(&block)
      end

      def query_parameters(&block)
        @request_schema.query_parameters = HashSchema.define(&block)
      end

      def headers(&block)
        @request_schema.headers = HashSchema.define(&block)
      end

    end # class RequestDef
  end
end # module Respect
