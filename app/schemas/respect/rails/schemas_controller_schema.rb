module Respect
  module Rails
    class SchemasControllerSchema < Respect::Rails::OldActionSchema
      def index
        request do |r|
          r.path_parameters do |s|
            s.string "format", in: %w{html json}
          end
        end
      end

      def doc
        request do |r|
          r.path_parameters do |s|
            s.string "format", in: %w{html json}
          end
        end
      end
    end
  end
end
