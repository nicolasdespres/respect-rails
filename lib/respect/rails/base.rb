module Respect
  module Rails
    class Base
      include ::Rails.application.routes.url_helpers

      class << self

        def controller_name
          name.sub(/Schema$/, '').underscore
        end

        def from_controller(controller_name, action_name = nil)
          begin
            klass = "#{controller_name}_schema".classify.constantize
          rescue NameError => e
            return nil
          end
          # We cannot instantiate the class inside the begin-rescue block
          # because NoMethodError is a sub-class of NameError and we do not
          # want to silently catch all NoMethodError that may be involved in
          # this process.
          if action_name
            klass.new(action_name)
          else
            klass
          end
        end

      end

      def initialize(action_name)
        @controller_name = self.class.controller_name
        @action_name = action_name
        @response_schemas = ResponseSchemaSet.new(controller_name, @action_name)
        send(@action_name) if respond_to?(@action_name)
      end

      attr_reader :controller_name, :action_name

      def define_request(&block)
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
    end
  end
end
