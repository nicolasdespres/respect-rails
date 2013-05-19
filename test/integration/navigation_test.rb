require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :all

  # FIXME(Nicolas Despres): Replace this test by lighter routes assertion
  # when we succeed to make them works on an isolated engine (the use_route
  # option does not seems to work here).
  test "get the full API doc" do
    get "/rest_spec"
    assert_response :success

    get "/rest_spec/doc"
    assert_response :success

    get "/rest_spec/doc.html"
    assert_response :success
  end

  test "params set by route are accepted" do
    get "/"
    assert_response :success
  end

  test "request HTTP headers validate successfully" do
    get "/automatic_validation/check_request_headers.json", {}, { "X-Test-Header" => "value" }
    assert_response :success
  end

  test "request HTTP headers fail to validate" do
    # We force request headers validation for the sake of automated tests.
    Respect::Rails::Engine.stubs(:disable_request_headers_validation).returns(false)
    assert_raises(Respect::Rails::RequestValidationError) do
      get "/automatic_validation/check_request_headers.json", {}, {"X-Test-Header" => "erroneous_value"}
    end
  end

end
