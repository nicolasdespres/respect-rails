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

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      # Set the request header so the request will be validated.
      set_request_header("HTTP_X_AB_SIGNATURE", "api_public_key")
      post :create, contact: { age: @contact.age, homepage: @contact.homepage, name: @contact.name }
    end

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should show contact" do
    get :show, id: @contact
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

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end

    assert_redirected_to contacts_path
  end

  private

  def set_request_header(key, value)
    # This is hacky but if should become easier with Rails 4 according
    # to ActionDispatch::Http::Headers new implementation.
    @request.instance_variable_get(:@env)[key] = value
  end
end
