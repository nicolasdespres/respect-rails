module Respect
  module Rails
    class SchemasControllerSchema < Respect::Rails::ActionSchema
      def index
        request do
          url_params do |s|
            s.string "format", in: %w{html json}
          end
        end
      end

      def doc
        request do
          url_params do |s|
            s.string "format", in: %w{html json}
          end
        end
      end
    end
  end
end
