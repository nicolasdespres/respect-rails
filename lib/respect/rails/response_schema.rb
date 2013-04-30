module Respect
  module Rails
    class ResponseSchema

      class << self

        def http_status(status)
          Rack::Utils.status_code(status)
        end

        def define(*args, &block)
          ResponseDef.eval(*args, &block)
        end

      end

      def initialize(status = :ok)
        @status = status
      end

      attr_reader :status

      def http_status
        self.class.http_status(@status)
      end

      attr_accessor :body

      delegate :validate, :validate?, :last_error, to: :body, allow_nil: true

      def ==(other)
        @status == other.status && @body == other.body
      end
    end
  end
end
