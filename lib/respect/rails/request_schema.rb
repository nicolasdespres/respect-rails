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
      end

      attr_reader :controller, :action

      attr_accessor :params

      delegate :validate, :validate?, :validate!, :last_error, to: :params, allow_nil: true
    end
  end
end
