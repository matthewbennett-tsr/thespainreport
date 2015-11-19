require 'test_helper'

class SalesemailsControllerTest < ActionController::TestCase
  setup do
    @salesemail = salesemails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:salesemails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create salesemail" do
    assert_difference('Salesemail.count') do
      post :create, salesemail: {  }
    end

    assert_redirected_to salesemail_path(assigns(:salesemail))
  end

  test "should show salesemail" do
    get :show, id: @salesemail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @salesemail
    assert_response :success
  end

  test "should update salesemail" do
    patch :update, id: @salesemail, salesemail: {  }
    assert_redirected_to salesemail_path(assigns(:salesemail))
  end

  test "should destroy salesemail" do
    assert_difference('Salesemail.count', -1) do
      delete :destroy, id: @salesemail
    end

    assert_redirected_to salesemails_path
  end
end
