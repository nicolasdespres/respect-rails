module Respect
  module Rails
    class ActionSchema
      include ::Rails.application.routes.url_helpers
      include Respect::DocHelper

      class << self

        def controller_name
          name.sub(/ControllerSchema$/, '').underscore
        end

        def from_controller(controller_name, action_name = nil)
          klass = "#{controller_name}_controller_schema".classify.safe_constantize

          return nil unless klass

          if action_name
            klass.new(action_name)
          else
            klass
          end
        end

        # Include +helper_module+ in the DSL definition classes, so that you can use its
        # methods for defining schema.
        #
        # Contrary to controllers' helpers the methods provided by the helper are available
        # in all schema definition throughout the application and not only when defining
        # schema in the scope of this controller schema.
        def helper(helper_module)
          Respect.extend_dsl_with(helper_module)
        end

      end

      def initialize(action_name)
        @controller_name = self.class.controller_name
        @action_name = action_name
        @response_schemas = ResponseSchemaSet.new(controller_name, @action_name)
        send(@action_name) if respond_to?(@action_name)
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
        request_schema || !response_schemas.empty?
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
