require 'respect/rails/engine'

module Respect
  module Rails
    extend ActiveSupport::Autoload

    autoload :ActionSchema
    autoload :ResponseSchemaSet
    autoload :RequestSchema
    autoload :ResponseSchema
    autoload :ActionDef
    autoload :RequestDef
    autoload :ResponseDef
    autoload :Info
    autoload :ApplicationInfo
    autoload :EngineInfo
    autoload :RouteInfo
    autoload :HeadersSimplifier

    class ValidationError < StandardError
      def initialize(error, part, object)
        @error = error
        @part = ActiveSupport::StringInquirer.new(part.to_s)
        @object = object
        @context = error.context + ["in #@part"]
      end

      attr_reader :error
      attr_reader :part
      attr_reader :context

      def message
        if ::Rails.env.test?
          @context.join("; ")
        else
          @error.message
        end
      end

      attr_reader :object

      def to_h
        {
          error: {
            class: self.class.name,
            message: message,
            context: context,
            part: @part,
            object: @object,
          }
        }
      end

      def to_json
        ActiveSupport::JSON.encode(self.to_h)
      end
    end

    # Raised when we fail to validate an incoming request.
    class RequestValidationError < ValidationError
    end

    # Raised when we fail to validate an outgoing response.
    class ResponseValidationError < ValidationError
    end

    class << self
      # Return the name of the application where Respect's engine is mounted.
      def application_name
        ::Rails.application.class.parent_name
      end

      # Shortcut for {Respect::Rails::Engine.setup}.
      def setup(&block)
        Engine.setup(&block)
      end
    end # class << self
  end # module Rails
end # module Respect
