module Respect
  module Rails
    class ApplicationInfo < EngineInfo

      def initialize(app_class)
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

    end # class ApplicationInfo
  end # module Rails
end # module Respect
