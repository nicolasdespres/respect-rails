module Respect
  module Rails
    module Helper
      extend ActiveSupport::Concern

      module Request
        # Return whether this request validates the schema.
        # You can get the validation error via {#last_validation_error}.
        def validate_schema?
          begin
            validate_schema
          rescue Respect::Rails::RequestValidationError
            false
          end
        end

        # Raise a {Respect::Rails::RequestValidationError} exception if this
        # request does not validate the schema.
        def validate_schema
          log_msg = "  Request validation: "
          valid = nil
          measure = Benchmark.realtime do
            valid = request_schema.validate!(self) unless request_schema.nil?
          end
          if valid.nil?
            log_msg += "none"
          else
            if valid == true
              log_msg += "success"
            else
              log_msg += "failure"
            end
          end
          log_msg += " (%.1fms)" % [ measure * 1000 ]
          ::Rails.logger.info log_msg
          if valid == false
            last_validation_error.context.each do |msg|
              ::Rails.logger.info "    #{msg}"
            end
            raise last_validation_error
          end
          true
        end

        def response_schema(http_status)
          unless action_schema.nil? || action_schema.response_schemas.nil?
            action_schema.response_schemas[http_status]
          end
        end

        def request_schema
          action_schema.request_schema if action_schema
        end

        attr_reader :action_schema
        attr_writer :action_schema
        private :action_schema=

        def last_validation_error
          request_schema.last_error
        end

        def body_parameters
          request_parameters
        end

      end # module Request

      module Response
        attr_reader :schema
        attr_writer :schema
        private :schema=

        def has_schema?
          !!@schema
        end

        # Return whether this response validates the schema.
        # You can get the validation error via {#last_validation_error}.
        def validate_schema?
          begin
            validate_schema
          rescue Respect::Rails::ResponseValidationError => e
            false
          end
        end

        # Raise a {Respect::Rails::ResponseValidationError} exception if this
        # response does not validate the schema.
        def validate_schema
          log_msg = "  Response validation: "
          valid = nil
          measure = Benchmark.realtime do
            if schema && content_type == Mime::JSON
              valid = schema.validate?(self)
            end
          end
          if valid.nil?
            log_msg += "none"
          else
            if valid
              log_msg += "success"
            else
              log_msg += "failure"
            end
          end
          log_msg += " (%.1fms)" % [ measure * 1000 ]
          ::Rails.logger.info log_msg
          if valid == false
            last_validation_error.context.each do |msg|
              ::Rails.logger.info "    #{msg}"
            end
            if Respect::Rails::Engine.catch_response_validation_error
              self.body = last_validation_error.to_json
              self.status = :internal_server_error
            else
              raise last_validation_error
            end
          end
          true
        end

        def last_validation_error
          schema.last_error
        end

      end # module Response

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

      # This "before" filter extends the request object with validation methods
      # and load the associated schema.
      def load_request_schema
        request.extend(Request)
        request.send(:action_schema=, Respect::Rails.load_schema(controller_name, action_name))
      end

      # This "after" filter extends the response object with validation methods
      # and load the associated schema.
      # You can safely call this filter multiple times (i.e. from other after
      # filters callbacks).
      def load_response_schema
        # If the request is instrumented.
        if request.respond_to? :response_schema
          # If the response is not already instrumented. This is necessary since
          # response validation after filter may have been executed first if it
          # is enabled.
          # When both load_schemas and validation_schemas are enabled callback
          # are called in this order:
          #   load_request_schema
          #   validate_request_schema
          #   controller's action
          #   validate_response_schema
          #   load_response_schema
          unless response.respond_to? :schema
            response.extend(Response)
            response.send(:schema=, request.response_schema(response.status))
          end
        end
      end
    end # module Helper
  end # module Rails
end # module Respect

ActionController::Base.send :include, Respect::Rails::Helper
