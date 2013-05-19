module Respect
  module Rails
    class ActionDef

      class << self
        def eval(*args, &block)
          new(*args).eval(&block)
        end
      end

      def initialize(*args)
        @action_schema = ActionSchema.new(*args)
      end

      def eval(&block)
        block.call(self)
        @action_schema
      end

      def request(&block)
        @action_schema.request = RequestSchema.define(@action_schema.controller_name,
          @action_schema.action_name, &block)
      end

      def response_for(&block)
        block.call(@action_schema.responses)
        @action_schema.responses
      end

      # Set the documentation to +text+.
      def documentation(text)
        @action_schema.documentation = text
      end

    end # class ActionDef
  end # module Rails
end # module Respect
