require 'test_helper'

class NotificationtypesControllerTest < ActionController::TestCase
  setup do
    @notificationtype = notificationtypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notificationtypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notificationtype" do
    assert_difference('Notificationtype.count') do
      post :create, notificationtype: {  }
    end

    assert_redirected_to notificationtype_path(assigns(:notificationtype))
  end

  test "should show notificationtype" do
    get :show, id: @notificationtype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @notificationtype
    assert_response :success
  end

  test "should update notificationtype" do
    patch :update, id: @notificationtype, notificationtype: {  }
    assert_redirected_to notificationtype_path(assigns(:notificationtype))
  end

  test "should destroy notificationtype" do
    assert_difference('Notificationtype.count', -1) do
      delete :destroy, id: @notificationtype
    end

    assert_redirected_to notificationtypes_path
  end
end
