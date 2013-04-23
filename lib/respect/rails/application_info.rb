module Respect
  module Rails
    class ApplicationInfo
      include Comparable

      def initialize(app)
        unless app.is_a?(::Rails::Application)
          raise "'#{app}' must be a rails application."
        end
        @app = app
      end

      attr_reader :app

      def name
        @app.class.parent_name
      end

      attr_accessor :routes

      def <=>(other)
        self.name <=> other.name
      end

    end # class ApplicationInfo
  end # module Rails
end # module Respect
