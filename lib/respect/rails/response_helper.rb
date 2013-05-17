module Respect
  module Rails
    module ResponseHelper
      extend ActiveSupport::Concern

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

    end # module ResponseHelper
  end # module Rails
end # module Respect

ActionDispatch::Response.send :include, Respect::Rails::ResponseHelper
