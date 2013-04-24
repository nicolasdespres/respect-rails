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
end
