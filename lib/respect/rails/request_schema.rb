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

      delegate :validate, :validate?, :validate!, :last_error, to: :params, allow_nil: true

      attr_reader :url_params, :body_params, :params

      def url_params=(url_params)
        update_params(@body_params, url_params)
        @url_params = url_params
      end

      def body_params=(body_params)
        update_params(body_params, @url_params)
        @body_params = body_params
      end

      private

      # We update the params value each time url_params or body_params changes, because we
      # must retains the stat of @params to handle consecutive call to {#validate} and {#last_error}
      def update_params(body_params, url_params)
        @params = (
          if url_params && body_params
            body_params.merge(url_params)
          elsif body_params
            body_params
          elsif url_params
            url_params
          else
            nil
          end
          )
      end

    end
  end
end
