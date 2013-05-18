module Respect
  module Rails
    class ActionSchema
      include Respect::DocHelper

      class << self
        def define(controller, action, &block)
          # FIXME(Nicolas Despres): Add ActionDef.
          instance = self.new(controller, action)
          block.call(instance)
          instance
        end
      end

      def initialize(controller_name, action_name)
        @controller_name = controller_name
        @action_name = action_name
        @response_schemas = ResponseSchemaSet.new(controller_name, @action_name)
      end

      attr_reader :controller_name, :action_name

      def request(&block)
        @request_schema = RequestSchema.define(controller_name, action_name, &block)
      end

      attr_reader :request_schema

      def response_for(&block)
        block.call(@response_schemas)
        @response_schemas
      end

      attr_reader :response_schemas

      def default_url_options
        {
          controller: @controller_name,
          action: @action_name,
          host: "example.org",
          format: "json",
        }
      end

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
