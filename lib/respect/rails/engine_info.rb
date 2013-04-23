module Respect
  module Rails
    class EngineInfo
      include Comparable

      def initialize(engine_class)
        unless engine_class < ::Rails::Engine
          raise "'#{engine_class}' must be an ancestor of ::Rails::Engine."
        end
        @engine_class = engine_class
      end

      attr_reader :engine_class

      def name
        @engine_class.engine_name.underscore
      end

      attr_accessor :routes

      def <=>(other)
        self.name <=> other.name
      end

    end # class EngineInfo
  end # module Rails
end # module Respect
