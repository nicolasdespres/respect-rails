module Respect
  module Rails
    class EngineInfo
      include Comparable

      def initialize(engine)
        unless engine < ::Rails::Engine
          raise "'#{engine}' must be a rails engine."
        end
        @engine = engine
      end

      attr_reader :engine

      def name
        @engine.engine_name.humanize
      end

      attr_accessor :routes

      def <=>(other)
        self.name <=> other.name
      end

    end # class EngineInfo
  end # module Rails
end # module Respect
