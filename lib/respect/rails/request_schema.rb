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

      # Validate +doc+ against a merged version of {#url_params} and {#body_params}.
      # Raise {RequestValidationError} if the validation process fails.
      def validate(doc)
        @last_params = body_params.merge(url_params)
        begin
          @last_params.validate(doc)
        rescue ValidationError => e
          raise RequestValidationError.new(e)
        end
      end

      # Get the last parameters schema used for validation.
      # Reset each time {#validate} is called.
      attr_reader :last_params

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
          last_params.sanitize_doc(doc, last_params.sanitized_doc)
        end
        valid
      end

    end
  end
end
