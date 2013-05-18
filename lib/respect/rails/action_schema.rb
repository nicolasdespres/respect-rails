module Respect
  module Rails
    class ActionSchema
      include Respect::DocHelper

      class << self
        def from_controller(controller_name, action_name)
          klass = "#{controller_name}_controller".classify.safe_constantize
          @schema = klass.new.action_schema(action_name) if klass
        end

        def define(*args, &block)
          ActionDef.eval(*args, &block)
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

      attr_accessor :request_schema

      attr_reader :response_schemas

      # Whether there is at least a request schema or one response schema for this action.
      def has_schema?
        request_schema || !response_schemas.empty? || documentation
      end

      attr_accessor :documentation
    end
  end
end
