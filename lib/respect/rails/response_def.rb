module Respect
  module Rails
    class ResponseDef

      class << self
        def eval(*args, &block)
          new(*args).eval(&block)
        end
      end

      def initialize(*args)
        @response_schema = ResponseSchema.new(*args)
      end

      def eval(&block)
        block.call(self)
        @response_schema
      end

      def body(&block)
        @response_schema.body = Schema.define(&block)
      end

      def body_with_object(&block)
        @response_schema.body = ObjectSchema.define(&block)
      end

    end # class ResponseDef
  end # module Rails
end # module Respect
