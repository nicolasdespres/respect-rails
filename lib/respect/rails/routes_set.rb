module Respect
  module Rails
    class RoutesSet

      def initialize
        @routes = collect_routes
      end

      attr_reader :routes

      def each(&block)
        @routes.each(&block)
      end

      private

      def collect_routes
        ::Rails.application.routes.routes.collect do |route|
          RouteWrapper.new(route)
        end.reject do |route|
          route.internal?
        end.sort
      end

    end # class RoutesSet
  end # module Rails
end # module Respect
