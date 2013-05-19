require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get index in JSON" do
    get :index, format: 'json'
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get new in JSON" do
    get :new, format: 'json'
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      # Rails 3 has no good support for headers in functional test. This test should failed normally
      # since the headers specified in the schema is not set. To let you do non-headers related test
      # anyway, we have disabled request headers validation in test mode by default.
      # See +Respect::Rails::Engine::disable_request_headers_validation+.
      post :create, contact: { age: @contact.age, homepage: @contact.homepage, name: @contact.name }
    end

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should create contact in JSON" do
    assert_difference('Contact.count') do
      # Rails 3 has no good support for headers in functional test. This test should failed normally
      # since the headers specified in the schema is not set. To let you do non-headers related test
      # anyway, we have disabled request headers validation in test mode by default.
      # See +Respect::Rails::Engine::disable_request_headers_validation+.
      post :create, format: 'json', contact: { age: @contact.age, homepage: @contact.homepage, name: @contact.name }
    end
    assert_response :created
  end

  test "should show contact" do
    get :show, id: @contact
    assert_response :success
  end

  test "should show contact in JSON" do
    get :show, format: 'json', id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact
    assert_response :success
  end

  test "should update contact" do
    put :update, id: @contact, contact: { age: @contact.age, homepage: @contact.homepage, name: @contact.name }
    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should update contact in JSON" do
    put :update, format: 'json', id: @contact, contact: { age: @contact.age, homepage: @contact.homepage, name: @contact.name }
    assert_response :no_content
  end

  test "should partially update contact in JSON" do
    put :update, format: 'json', id: @contact, contact: { age: (@contact.age + 1) }
    assert_response :no_content
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end

    assert_redirected_to contacts_path
  end

  test "should destroy contact in JSON" do
    assert_difference('Contact.count', -1) do
      delete :destroy, format: 'json', id: @contact
    end
    assert_response :no_content
  end

end
