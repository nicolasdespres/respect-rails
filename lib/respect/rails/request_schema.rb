module Respect
  module Rails
    class RequestSchema

      class << self
        def define(*args, &block)
          RequestDef.eval(*args, &block)
        end
      end

      def initialize(controller, action)
        @controller = controller
        @action = action
        @default_url_params = ObjectSchema.define do |s|
          s.string "controller", equal_to: @controller.to_s, doc: false
          s.string "action", equal_to: @action.to_s, doc: false
        end
        @url_params = @default_url_params.dup
        @body_params = ObjectSchema.new
      end

      attr_reader :controller, :action

      attr_accessor :body_params

      attr_reader :url_params, :default_url_params

      # Merge +url_params+ with {#default_url_params} and store it.
      def url_params=(url_params)
        @url_params = @default_url_params.merge(url_params)
      end

      # Validate +doc+ against {#body_params} and {#url_params}.
      # Raise a {RequestValidationError} if an +doc+ is invalid.
      # Returns +true+ on success.
      def validate(doc)
        begin
          url_params.validate(doc)
        rescue Respect::ValidationError => e
          raise RequestValidationError.new(e, :url)
        end
        begin
          body_params.validate(doc)
        rescue Respect::ValidationError => e
          raise RequestValidationError.new(e, :body)
        end
        true
      end

      def validate?(doc)
        begin
          validate(doc)
          true
        rescue RequestValidationError => e
          @last_error = e
          false
        end
      end

      # Return the last validation error that happens during the
      # validation process. (set by {#validate?})
      # Reset each time {#validate?} is called.
      attr_reader :last_error

      def validate!(doc)
        valid = validate?(doc)
        if valid
          url_params.sanitize_doc!(doc, url_params.sanitized_doc)
          body_params.sanitize_doc!(doc, body_params.sanitized_doc)
        end
        valid
      end

    end
  end
end
