module Respect
  module Rails
    module UnitTestHelper
      def assert_schema_validate_response
        return unless response.has_schema?
        if !response.validate_schema?
          assert false, response.last_validation_error.context.join(" ")
        end
      end
    end # module UnitTestHelper
  end # module Rails
end # module Respect

ActionController::TestCase.send :include, Respect::Rails::UnitTestHelper
