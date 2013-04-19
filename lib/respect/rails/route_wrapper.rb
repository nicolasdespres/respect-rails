module Respect
  module Rails
    # A wrapper around ActionDispatch::Routing::Route. It provides only
    # access to the information we need when generating doc.
    # It is very strongly inspired from ActionDispatch::Routing::RouteWrapper class
    # which is internal and designed to be used with
    # ActionDispoatch::Routing::RouteInspector. These class are not meant
    # to be used by external user as far as I can read in rails code base.
    # So, we made up our own so that we can easily adjust it to our need.
    class RouteWrapper
      include Comparable

      def initialize(route)
        @route = route
      end

      attr_reader :route

      def path
        @route.path.spec.to_s
      end

      def internal?
        path =~ %r{\A#{::Rails.application.config.assets.prefix}} \
        || controller_name =~ /info|respect/ \
        || route_to_me?
      end

      def <=>(other)
        self.path <=> other.path
      end

      def verb
        @route.verb.source.gsub(/[$^]/, '')
      end

      def controller_name
        @route.requirements[:controller] || ':controller'
      end

      def action_name
        @route.requirements[:action] || ':action'
      end

      def schema_set
        @controller ||= Base.from_controller(controller_name, action_name)
      end

      def spec
        "#{verb} #{path}"
      end

      def url
        if schema_set
          options = schema_set.default_url_options
        else
          options = @route.defaults.merge({ format: 'json' })
        end
        ::Rails.application.routes.url_for(options)
      end

      def engine?
        @route.app.is_a? ::Rails::Engine
      end

      def route_to_me?
        @route.app == Engine
      end

    end # class RouteWrapper
  end # module Rails
end # module Respect
