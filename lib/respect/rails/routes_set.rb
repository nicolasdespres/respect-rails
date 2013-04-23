module Respect
  module Rails
    # The implementation is strongly inspired from
    # ActionDispatch::Routing::RoutesInspector.
    class RoutesSet

      def initialize
        @engines = {}
        @engines["application"] = collect_routes(::Rails.application.routes.routes)
      end

      attr_reader :engines

      def routes
        @engines["application"]
      end

      def each(&block)
        routes.each(&block)
      end

      private

      def collect_routes(routes, mounted_point = nil)
        result = []
        routes.each do |route|
          route = RouteWrapper.new(route, mounted_point)
          next if route.internal?
          if route.engine?
            result += collect_engine_routes(route)
          else
            result << route
          end
        end
        result.sort!
      end

      def collect_engine_routes(route)
        return unless route.engine?
        name = route.endpoint
        return if @engines[name]

        routes = route.rack_app.routes
        if routes.is_a?(ActionDispatch::Routing::RouteSet)
          @engines[name] = collect_routes(routes.routes, route)
        else
          []
        end
      end

    end # class RoutesSet
  end # module Rails
end # module Respect
