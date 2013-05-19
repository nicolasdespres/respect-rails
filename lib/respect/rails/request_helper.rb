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
        @validated = nil
        measure = Benchmark.realtime do
          @validated = request_schema.validate?(self) unless request_schema.nil?
        end
        if @validated.nil?
          log_msg += "none"
        else
          if @validated == true
            log_msg += "success"
          else
            log_msg += "failure"
          end
        end
        log_msg += " (%.1fms)" % [ measure * 1000 ]
        ::Rails.logger.info log_msg
        if @validated == false
          last_validation_error.context.each do |msg|
            ::Rails.logger.info "    #{msg}"
          end
          raise last_validation_error
        end
        true
      end

      def response_schema(http_status)
        unless action_schema.nil? || action_schema.responses.nil?
          action_schema.responses[http_status]
        end
      end

      def request_schema
        action_schema.request if action_schema
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

      # Returns the sanitized parameters if the schema validation has succeed.
      def sane_params
        request_schema.sanitized_params if request_schema
      end

      # Returns +nil+ if never validated, +true+ if validated successfully and
      # +false+ if validation failed.
      def validated
        @validated
      end

      # Sanitize all the request's parameters (path, query and body) *in-place*.
      # if the schema validation has succeed. Validate it first if it has not
      # been yet.
      def sanitize_params!
        if request_schema
          if validated.nil?
            validate_schema
          end
          if validated == true
            request_schema.sanitize!(self)
          end
        end
      end

    end # module RequestHelper
  end # module Rails
end # module Respect

ActionDispatch::Request.send :include, Respect::Rails::RequestHelper
