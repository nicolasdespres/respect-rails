require 'respect'

require 'respect/rails/helper'

module Respect
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Respect::Rails
      engine_name 'respect'

      initializer "respect.install_macros" do
        Respect::Rails.install_macros
      end
    end # class Engine

  end # module Rails
end # module Respect
