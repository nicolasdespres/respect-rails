module Respect
  module Rails
    # The implementation is strongly inspired from
    # ActionDispatch::Routing::RoutesInspector.
    class RoutesSet
      include Enumerable

      def initialize
        @engines = {}
        @engines[app_name] = collect_routes(::Rails.application.routes.routes)
      end

      attr_reader :engines

      def routes
        @engines[app_name]
      end

      def app_name
        @app_name ||= Rails.application_name
      end

      delegate :each, to: :routes

      # Call _block_ for each collected engines. They are yield in alphabetic order.
      def each_engine(&block)
        @engines.keys.sort.each{|k| block.call(k, @engines[k]) }
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
        name = route.endpoint_name
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
