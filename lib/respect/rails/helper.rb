require 'respect/rails/request_helper'
require 'respect/rails/response_helper'

module Respect
  module Rails
    module Helper
      extend ActiveSupport::Concern

      included do |base|
        around_filter :load_schemas
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
      end

      private

      # This "around" filter calls +validation_request_schema+ and +validation_response_schema+
      # respectively before and after the controller's action.
      def validate_schemas
        validate_request_schema
        yield
        validate_response_schema if Respect::Rails::Engine.validate_response
      end

      # This "before" filter validates the request if it has been instrumented.
      def validate_request_schema
        request.validate_schema if request.respond_to? :validate_schema
      end

      # This "after" filter validates the response with the schema associated to the
      # response status if one is found in the instrumented request.
      def validate_response_schema
        load_response_schema
        response.validate_schema if response.respond_to? :validate_schema
      end

      # This "around" filter calls +load_request_schema+ and +load_response_schema+
      # respectively before and after the controller's action. It is useful
      # if you want to do the validation yourself. It only instruments the request
      # and the response object.
      def load_schemas
        load_request_schema
        yield
        if Respect::Rails::Engine.validate_response || Respect::Rails::Engine.load_response_schema
          load_response_schema
        end
      end

      # This "before" filter load and attach the action schema to the request object.
      # It is safe to call this method several times.
      def load_request_schema
        request.send(:action_schema=, Respect::Rails.load_schema(controller_name, action_name)) unless request.has_schema?
      end

      # This "after" filter attach the response schema to the response object.
      # You can safely call this filter multiple times (i.e. from other after
      # filters callbacks).
      def load_response_schema
        response.send(:schema=, request.response_schema(response.status)) unless response.has_schema?
      end

      # Before filter which sanitize all request parameters: +params+,
      # +query_parameters+, +path_parameters+ and +request_parameters+.
      # The request have to be validated first.
      #
      # Example:
      #   class UsersController < ApplicationController
      #     around_filter :validate_schemas
      #     before_filter :sanitize_params
      #   end
      def sanitize_params
        request.sanitize_params!
      end
    end # module Helper
  end # module Rails
end # module Respect

ActionController::Base.send :include, Respect::Rails::Helper
