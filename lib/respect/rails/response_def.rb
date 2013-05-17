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

      # Define the schema of the response body.
      # @option options [Boolean] hash (true) whether the body is hash schema.
      def body(options = {}, &block)
        @response_schema.body = (
          if options.fetch(:hash, true)
            HashSchema.define(&block)
          else
            Schema.define(&block)
          end
          )
      end

      def headers(options = {}, &block)
        @response_schema.headers = HashSchema.define(options, &block)
      end

    end # class ResponseDef
  end # module Rails
end # module Respect
