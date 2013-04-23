module Respect
  module Rails
    class ApplicationInfo < EngineInfo

      def initialize(app)
        super(app.class)
        unless app.is_a?(::Rails::Application)
          raise "'#{app}' must be a rails application."
        end
        @app = app
      end

      attr_reader :app

      def name
        @app.class.parent_name.underscore
      end

    end # class ApplicationInfo
  end # module Rails
end # module Respect
