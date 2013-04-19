require 'test_helper'

class BaseTest < ActiveSupport::TestCase
  test "instantiating from controller do not catch NoMethodError" do
    assert_raise(NoMethodError) do
      Respect::Rails::Base.from_controller(:automatic_validation, :raise_no_method_error)
    end
  end

  test "instantiating from controller do not catch NameError" do
    assert_raise(NameError) do
      Respect::Rails::Base.from_controller(:automatic_validation, :raise_name_error)
    end
  end

  test "url_for is working" do
    s = Respect::Rails::Base.from_controller(:automatic_validation, :basic_get)
    assert_equal("http://my_application.org/automatic_validation/basic_get.json",
      s.url_for)
  end

  test "have working _url helper" do
    s = Respect::Rails::Base.from_controller(:automatic_validation, :basic_get)
    assert_equal("http://my_application.org/automatic_validation/basic_get.json",
      s.automatic_validation_basic_get_url(format: "json"))
  end

  test "have working _path helper" do
    s = Respect::Rails::Base.from_controller(:automatic_validation, :basic_get)
    assert_equal("/automatic_validation/basic_get.json",
      s.automatic_validation_basic_get_path(format: "json"))
  end

  test "have other schema helper" do
    s = Respect::Rails::Base.from_controller(:automatic_validation, :basic_get)
    assert_equal("http://my_application.org/no_schema/basic.json",
      s.no_schema_basic_url(format: "json"))
  end
end
