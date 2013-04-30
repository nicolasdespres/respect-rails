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

  def test_def_from_file_if_no_block
    rss = Respect::Rails::ResponseSchemaSet.new("c", "a")
    rs = Respect::Rails::ResponseSchema.new
    assert(!rss[200].equal?(rs))
    filename = "#{::Rails.root}/app/schemas/c/a.schema"
    File.stubs(:exists?).with(filename).returns(true)
    File.stubs(:exists?).with("#{::Rails.root}/app/schemas/c/a-ok.schema").returns(false)
    Respect::Rails::ResponseSchema.stubs(:from_file).with(:ok, filename).returns(rs)
    rss.ok
    assert(rss[200].equal?(rs))
  end
end
