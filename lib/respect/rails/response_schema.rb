module Respect
  module Rails
    class ResponseSchema
      include HeadersSimplifier
      include Respect::DocHelper

      class << self

        def http_status(status)
          Rack::Utils.status_code(status)
        end

        # FIXME(Nicolas Despres): Move me to another module/class.
        def symbolize_http_status(http_status)
          h = Rack::Utils::HTTP_STATUS_CODES
          (h[http_status] || h[500]).downcase.gsub(/\s|-/, '_').to_sym
        end

        def define(*args, &block)
          ResponseDef.eval(*args, &block)
        end

        # Read the response schema definition from the given +filename+ and
        # evaluate it as a block passed to {ResponseSchema.define}
        def from_file(status, filename)
          define(status) do |r|
            r.instance_eval(File.read(filename), filename)
          end
        end
      end

      def initialize(status = :ok)
        @status = status
        @headers = HashSchema.new
      end

      attr_reader :status

      def http_status
        self.class.http_status(@status)
      end

      attr_accessor :body

      def ==(other)
        @status == other.status && @body == other.body
      end

      def validate(response)
        if headers
          begin
            headers.validate(response.headers)
          rescue Respect::ValidationError => e
            raise Respect::Rails::ResponseValidationError.new(e, :headers, simplify_headers(response.headers))
          end
        end
        if body
          decoded_body = ActiveSupport::JSON.decode(response.body)
          begin
            body.validate(decoded_body)
          rescue Respect::ValidationError => e
            raise Respect::Rails::ResponseValidationError.new(e, :body, decoded_body)
          end
        end
        true
      end

      def validate?(response)
        begin
          validate(response)
          true
        rescue Respect::Rails::ResponseValidationError => e
          @last_error = e
          false
        end
      end

      attr_reader :last_error

      attr_accessor :headers
      attr_accessor :documentation
    end
  end
end
