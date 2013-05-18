module Respect
  module Rails
    module ControllerHelper
      extend ActiveSupport::Concern

      included do |base|
        around_filter :load_schemas!
      end

      module ClassMethods
        # Install a handler for {Respect::Rails::RequestValidationError}. It provides a more specific
        # error report than the default exception handler in development. For instance you get the
        # context of where the error happened in the JSON document.
        #
        # Example:
        #   # In your ApplicationController class.
        #   rescue_from_request_valiation_error if Rails.env.development?
        def rescue_from_request_validation_error
          rescue_from Respect::Rails::RequestValidationError do |exception|
            respond_to do |format|
              format.html do
                @error = exception
                render template: "respect/rails/request_validation_exception", layout: false, status: :internal_server_error
              end
              format.json do
                render json: exception.to_json, status: :internal_server_error
              end
            end
          end
        end

        # FIXME(Nicolas Despres): Document me.
        def def_action_schema(action_name, &block)
          define_method("#{action_name}_schema") do
            Respect::Rails::ActionSchema.define(self, action_name, &block)
          end
        end
      end

      # FIXME(Nicolas Despres): Test me!!!
      def action_schema(action = nil)
        action ||= self.action_name
        method_name = "#{action}_schema"
        if self.respond_to?(method_name)
          send(method_name)
        end
      end

      private

      # This "around" filter calls +validation_request_schema+ and +validation_response_schema+
      # respectively before and after the controller's action.
      def validate_schemas!
        validate_request_schema!
        yield
        validate_response_schema! if Respect::Rails::Engine.validate_response
      end

      # This "before" filter validates the request.
      def validate_request_schema!
        request.validate_schema
      end

      # This "after" filter validates the response with the schema associated to the
      # response status if one is found.
      def validate_response_schema!
        load_response_schema!
        response.validate_schema
      end

      # This "around" filter calls +load_request_schema+ and +load_response_schema+
      # respectively before and after the controller's action. It is useful
      # if you want to do the validation yourself. It only load the action schema
      # and attach the request schema to the request object and the response schema to
      # the response object.
      def load_schemas!
        load_request_schema!
        yield
        if Respect::Rails::Engine.validate_response
          load_response_schema!
        end
      end

      # This "before" filter load and attach the action schema to the request object.
      # It is safe to call this method several times.
      def load_request_schema!
        unless request.has_schema?
          schema = action_schema
          # FIXME(Nicolas Despres): Remove me once OldActionSchema has been removed
          schema ||= Respect::Rails.load_schema(controller_name, action_name)
          request.send(:action_schema=, schema)
        end
      end

      # This "after" filter attach the response schema to the response object.
      # You can safely call this filter multiple times (i.e. from other after
      # filters callbacks).
      def load_response_schema!
        response.send(:schema=, request.response_schema(response.status)) unless response.has_schema?
      end

      # Before filter which sanitize all request parameters: +params+,
      # +query_parameters+, +path_parameters+ and +request_parameters+.
      # The request is validated first if it has not been yet.
      def sanitize_params!
        request.sanitize_params!
      end
    end # module ControllerHelper
  end # module Rails
end # module Respect

ActionController::Base.send :include, Respect::Rails::ControllerHelper
