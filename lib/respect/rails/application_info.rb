module Respect
  module Rails
    class ApplicationInfo < EngineInfo
      include Respect::DocHelper

      def initialize(app_class = ::Rails.application.class)
        super(app_class)
        unless app_class < ::Rails::Application
          raise "'#{app_class}' must be an ancestor of ::Rails::Application."
        end
        @app_class = app_class
      end

      attr_reader :app_class

      def name
        @app_class.parent_name.underscore
      end

      def documentation
        Respect::Rails::Engine.app_documentation
      end

    end # class ApplicationInfo
  end # module Rails
end # module Respect
