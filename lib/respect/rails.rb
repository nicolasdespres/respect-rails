require 'respect/rails/engine'

module Respect
  module Rails
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :ResponseSchemaSet
    autoload :RouteWrapper
    autoload :RoutesSet
    autoload :RequestSchema
    autoload :ResponseSchema
    autoload :RequestDef
    autoload :ResponseDef

    class << self
      def load_schema(controller_name, action_name)
        Base.from_controller(controller_name, action_name)
      end

      # Install all user-defined macros in app/helpers/respect and extend the DSL with
      # them.
      def install_macros
        Pathname.glob("#{::Rails.root}/app/helpers/#{self.name.underscore}/*_macros.rb") do |path|
          require path.to_s
          module_name = path.sub_ext('').sub(%r{^#{::Rails.root}/app/helpers/}, '').to_s
          self.extend_dsl_with(module_name.camelize.constantize)
        end
      end
    end # class << self
  end # module Rails
end # module Respect
