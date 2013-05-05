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
        @default_path_parameters = ObjectSchema.define do |s|
          s.string "controller", equal_to: @controller.to_s, doc: false
          s.string "action", equal_to: @action.to_s, doc: false
        end
        @path_parameters = @default_path_parameters.dup
        @body_params = ObjectSchema.new
      end

      attr_reader :controller, :action

      attr_accessor :body_params

      attr_reader :path_parameters, :default_path_parameters

      # Merge +path_parameters+ with {#default_path_parameters} and store it.
      def path_parameters=(path_parameters)
        @path_parameters = @default_path_parameters.merge(path_parameters)
      end

      # Validate +doc+ against {#body_params} and {#path_parameters}.
      # Raise a {RequestValidationError} if an +doc+ is invalid.
      # Returns +true+ on success.
      def validate(doc)
        begin
          path_parameters.options[:strict] = false
          path_parameters.validate(doc)
        rescue Respect::ValidationError => e
          raise RequestValidationError.new(e, :path)
        end
        begin
          body_params.options[:strict] = false
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
          path_parameters.sanitize_doc!(doc, path_parameters.sanitized_doc)
          body_params.sanitize_doc!(doc, body_params.sanitized_doc)
        end
        valid
      end

    end
  end
end
