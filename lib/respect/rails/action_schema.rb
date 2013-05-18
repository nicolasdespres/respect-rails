module Respect
  module Rails
    class ActionSchema
      include Respect::DocHelper

      class << self
        def from_controller(controller_name, action_name)
          klass = "#{controller_name}_controller".classify.safe_constantize
          @schema = klass.new.action_schema(action_name) if klass
        end

        def define(controller, action_name, &block)
          # FIXME(Nicolas Despres): Add ActionDef.
          instance = self.new(controller, action_name)
          block.call(instance)
          instance
        end
      end

      def initialize(controller, action_name)
        @controller = controller
        @action_name = action_name
        @response_schemas = ResponseSchemaSet.new(controller_name, @action_name)
      end

      attr_reader :controller, :action_name

      def controller_name
        @controller.controller_name
      end

      def request(&block)
        @request_schema = RequestSchema.define(controller_name, action_name, &block)
      end

      attr_reader :request_schema

      def response_for(&block)
        block.call(@response_schemas)
        @response_schemas
      end

      attr_reader :response_schemas

      # Whether there is at least a request schema or one response schema for this action.
      def has_schema?
        request_schema || !response_schemas.empty? || documentation
      end

      # Returns the documentation of this action schema if +text+ is +nil+.
      # Set the documentation to +text+ if not +nil+.
      def documentation(text = nil)
        if text
          @doc = text
        else
          @doc
        end
      end

    end
  end
end
