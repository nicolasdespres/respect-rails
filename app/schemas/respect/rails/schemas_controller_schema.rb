module Respect
  module Rails
    class SchemasControllerSchema < Respect::Rails::ActionSchema
      def index
        request do |r|
          r.url_params do |s|
            s.string "format", in: %w{html json}
          end
        end
      end

      def doc
        request do |r|
          r.url_params do |s|
            s.string "format", in: %w{html json}
          end
        end
      end
    end
  end
end
