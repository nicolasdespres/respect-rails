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
        self.instance_exec(self, &block)
        @request_schema
      end

      def url_params(&block)
        @request_schema.url_params.eval(&block)
      end

      def body_params(&block)
        @request_schema.body_params = ObjectSchema.define(&block)
      end

    end # class RequestDef
  end
end # module Respect
