require "test_helper"

class ResponseSchemaSetTest < Test::Unit::TestCase
  def test_each_response_file_works
    expected = [
      [ "#{Rails.root}/app/schemas/automatic_validation/response_schema_from_file-created.schema", :created ],
      [ "#{Rails.root}/app/schemas/automatic_validation/response_schema_from_file-unprocessable_entity.schema", :unprocessable_entity ],
    ].sort
    actual = []
    Respect::Rails::ResponseSchemaSet.each_response_file("automatic_validation", "response_schema_from_file") do |path, status|
      actual << [ path.to_s, status ]
    end
    assert_equal expected, actual
  end

  def test_respond_to_object_method
    assert_respond_to Respect::Rails::ResponseSchemaSet.new("automatic_validation", "response_schema_from_file"), :class
  end
end
