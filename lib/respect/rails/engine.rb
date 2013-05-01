require 'respect'

require 'respect/rails/helper'

module Respect
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Respect::Rails
      engine_name 'respect'

    end # class Engine

  end # module Rails
end # module Respect
