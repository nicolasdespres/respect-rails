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
        @request_parameters = ObjectSchema.new
      end

      attr_reader :controller, :action

      attr_accessor :request_parameters

      attr_reader :path_parameters, :default_path_parameters

      # Merge +path_parameters+ with {#default_path_parameters} and store it.
      def path_parameters=(path_parameters)
        @path_parameters = @default_path_parameters.merge(path_parameters)
      end

      # Validate +doc+ against {#request_parameters} and {#path_parameters}.
      # Raise a {RequestValidationError} if an +doc+ is invalid.
      # Returns +true+ on success.
      def validate(request)
        begin
          path_parameters.options[:strict] = false
          path_parameters.validate(request.params)
        rescue Respect::ValidationError => e
          raise RequestValidationError.new(e, :path)
        end
        begin
          request_parameters.options[:strict] = false
          request_parameters.validate(request.params)
        rescue Respect::ValidationError => e
          raise RequestValidationError.new(e, :request)
        end
        true
      end

      def validate?(request)
        begin
          validate(request)
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

      def validate!(request)
        valid = validate?(request)
        if valid
          path_parameters.sanitize_doc!(request.params)
          request_parameters.sanitize_doc!(request.params)
        end
        valid
      end

    end
  end
end
