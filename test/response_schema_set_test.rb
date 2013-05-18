require "test_helper"

class ResponseSchemaSetTest < Test::Unit::TestCase
  def test_respond_to_object_method
    assert_respond_to Respect::Rails::ResponseSchemaSet.new("automatic_validation", "response_schema_from_file"), :class
  end

  def test_normalize_status
    assert_equal :ok, Respect::Rails::ResponseSchemaSet.symbolize_status(:ok)
    assert_equal :ok, Respect::Rails::ResponseSchemaSet.symbolize_status("ok")
    assert_equal :ok, Respect::Rails::ResponseSchemaSet.symbolize_status(200)
    assert_equal :ok, Respect::Rails::ResponseSchemaSet.symbolize_status("200")
    assert_equal :ok, Respect::Rails::ResponseSchemaSet.symbolize_status(200.5)
    assert_raises(ArgumentError) do
      Respect::Rails::ResponseSchemaSet.symbolize_status(Object.new)
    end
  end
end
