require 'respect/rails/engine'

module Respect
  module Rails
    extend ActiveSupport::Autoload

    autoload :ActionSchema
    autoload :ResponseSchemaSet
    autoload :RequestSchema
    autoload :ResponseSchema
    autoload :RequestDef
    autoload :ResponseDef
    autoload :Info
    autoload :ApplicationInfo
    autoload :EngineInfo
    autoload :RouteInfo

    # Raised when we fail to validate an incoming request.
    class RequestValidationError < StandardError
      def initialize(validation_error)
        @validation_error = validation_error
      end

      attr_reader :validation_error
      delegate :context, :message, to: :@validation_error
    end

    class << self
      def load_schema(controller_name, action_name)
        ActionSchema.from_controller(controller_name, action_name)
      end

      # Return the name of the application where Respect's engine is mounted.
      def application_name
        ::Rails.application.class.parent_name
      end
    end # class << self
  end # module Rails
end # module Respect
