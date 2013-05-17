module Respect
  module Rails
    module RequestHelper
      extend ActiveSupport::Concern

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
          valid = request_schema.validate?(self) unless request_schema.nil?
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

      def has_schema?
        !!action_schema
      end

      def last_validation_error
        request_schema.last_error
      end

      def body_parameters
        request_parameters
      end

      # Returns the sanitized parameters if the schema validation has succeed.
      def sane_params
        request_schema.sanitized_params if request_schema
      end

      # Sanitize all the request's parameters (path, query and body) *in-place*.
      # if the schema validation has succeed.
      def sanitize_params!
        request_schema.sanitize!(self) if sane_params
      end

    end # module RequestHelper
  end # module Rails
end # module Respect

ActionDispatch::Request.send :include, Respect::Rails::RequestHelper
