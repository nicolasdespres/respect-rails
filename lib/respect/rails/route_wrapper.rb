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

      def initialize(route, mount_point)
        @route = route
        if !mount_point.is_a?(self.class) && !mount_point.nil? && !mount_point.engine?
          raise "'#{mount_point.inspect}' must be a route to an engine if set"
        end
        @mount_point = mount_point
      end

      attr_reader :route, :mount_point

      def path
        path = @route.path.spec.to_s
        if @mount_point
          path = @mount_point.path + path
        end
        if path.length > 1 && path =~ %r{/$}
          path.chop!
        end
        path
      end

      def internal?
        path =~ %r{\A#{::Rails.application.config.assets.prefix}} \
        || controller_name =~ %r{\Arails/(info|welcome)}
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
        "#{verb} #{path}".strip
      end

      def url
        if schema_set
          options = schema_set.default_url_options
        else
          options = @route.defaults.merge({ format: 'json' })
        end
        ::Rails.application.routes.url_for(options)
      end

      def endpoint
        rack_app ? rack_app.inspect : "#{controller}##{action}"
      end

      def rack_app(app = @route.app)
        @rack_app ||= begin
          class_name = app.class.name.to_s
          if class_name == "ActionDispatch::Routing::Mapper::Constraints"
            rack_app(app.app)
          elsif ActionDispatch::Routing::Redirect === app || class_name !~ /^ActionDispatch::Routing/
            app
          end
        end
      end

      def engine?
        rack_app && rack_app.respond_to?(:routes)
      end

    end # class RouteWrapper
  end # module Rails
end # module Respect
