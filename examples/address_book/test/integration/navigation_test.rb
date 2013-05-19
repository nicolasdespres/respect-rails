require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "contacts create requires custom header" do
    post("/contacts.json",
      {
        contact: {
          name: contacts(:one).name,
          age: contacts(:one).age,
          homepage: contacts(:one).homepage,
        },
      },
      { "HTTP_X_AB_SIGNATURE" => "api_public_key" })
    assert_response :success
  end

end
