module Respect
  module Rails
    # Controller to get all the information relative to the
    # REST API of this application.
    class SchemasController < ActionController::Base
      def_action_schema :index do |s|
        s.request do |r|
          r.path_parameters do |s|
            s.string "format", in: %w{html json}
          end
        end
      end

      def index
        respond_to do |format|
          format.html # index.html.erb
        end
      end

      def_action_schema :doc do |s|
        s.request do |r|
          r.path_parameters do |s|
            s.string "format", in: %w{html json}
          end
        end
      end

      def doc
        @info = Respect::Rails::Info.new
        respond_to do |format|
          format.html # doc.html.erb
        end
      end
    end
  end # module Rails
end # module Respect
