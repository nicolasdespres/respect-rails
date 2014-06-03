require "test_helper"

class ExplainOptionsTest < Test::Unit::TestCase
  def test_explain_validator_option
    s = Respect::IntegerSchema.new(equal_to: 42)
    v = Respect::EqualToValidator.new(42)
    Respect::EqualToValidator.expects(:new).with(42).returns(v).once
    result = "a string"
    v.stubs(:explain).returns(result).once
    assert_equal result.object_id, s.explain_option(:equal_to).object_id
  end

  def test_explain_unknown_option
    s = Respect::IntegerSchema.new(unknown: 42)
    assert_kind_of String, s.explain_option(:unknown)
  end

  def test_explain_required_with_no_default_value
    s = Respect::IntegerSchema.new(required: true)
    explanation = s.explain_option(:required)
    assert_equal("Is required.", explanation)
  end

  def test_explain_optional_with_no_default_value
    s = Respect::IntegerSchema.new(required: false)
    explanation = s.explain_option(:required)
    assert_equal("Is optional.", explanation)
  end

  def test_explain_optional_with_default_value
    s = Respect::IntegerSchema.new(default: 42)
    explanation = s.explain_option(:required)
    assert_equal("Is optional.", explanation)
  end
end
