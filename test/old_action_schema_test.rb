require 'test_helper'

class OldActionSchemaTest < ActiveSupport::TestCase

  test "has_schema" do
    assert(!Respect::Rails::OldActionSchema.from_controller(:automatic_validation, :no_schema_at_all).has_schema?)
    assert(Respect::Rails::OldActionSchema.from_controller(:automatic_validation, :response_schema_from_file).has_schema?)
    assert(Respect::Rails::OldActionSchema.from_controller(:automatic_validation, :response_schema_from_file_unknown_status).has_schema?)
  end
end
