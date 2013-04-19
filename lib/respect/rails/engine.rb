module Respect
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Respect::Rails
    end
  end
end
