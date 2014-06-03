require "test_helper"

class SchemasHelperTest < Test::Unit::TestCase
  def setup
    @schemas = Object.new
    @schemas.extend(Respect::Rails::SchemasHelper)
  end

  def test_describe_option
    assert_nil @schemas.describe_option(:doc, "value")
    assert_nil @schemas.describe_option(:required, true)
    assert_nil @schemas.describe_option(:default, nil)
    assert_equal @schemas.describe_option(:default, 42), "default to 42"
    assert_equal @schemas.describe_option(:equal_to, 42), "Must be equal to 42"
    assert_equal @schemas.describe_option(:allow_nil, 42), "May be null"
    assert_nil @schemas.describe_option(:allow_nil, nil)
    assert_equal @schemas.describe_option(:strict, 42), "Must contains exactly these parameters"
    assert_nil @schemas.describe_option(:strict, nil)
    assert_equal @schemas.describe_option(:greater_than, 42), "Must be greater than 42"
    assert_equal @schemas.describe_option(:non_existent_option, 42), "non_existent_option: 42"
    assert @schemas.describe_option(:default, "<script>42</script>").html_safe?, "Respect::Rails::SchemasHelper#describe_option return's is not HTML safe."
  end

  def test_build_parameter_name
    assert_equal @schemas.build_parameter_name([:test, :parameters, 42]), "test[parameters][42]"
  end
end
