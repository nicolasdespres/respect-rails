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

      def params(&block)
        @request_schema.params = ObjectSchema.define do |s|
          s.string "format", equal_to: "json"
          s.string "controller", equal_to: @request_schema.controller.to_s
          s.string "action", equal_to: @request_schema.action.to_s
          s.eval(&block)
        end
      end

    end # class RequestDef
  end
end # module Respect
