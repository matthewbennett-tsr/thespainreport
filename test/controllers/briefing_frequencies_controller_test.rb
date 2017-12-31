require 'test_helper'

class BriefingFrequenciesControllerTest < ActionController::TestCase
  setup do
    @briefing_frequency = briefing_frequencies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:briefing_frequencies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create briefing_frequency" do
    assert_difference('BriefingFrequency.count') do
      post :create, briefing_frequency: { briefing_frequency: @briefing_frequency.briefing_frequency, name: @briefing_frequency.name }
    end

    assert_redirected_to briefing_frequency_path(assigns(:briefing_frequency))
  end

  test "should show briefing_frequency" do
    get :show, id: @briefing_frequency
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @briefing_frequency
    assert_response :success
  end

  test "should update briefing_frequency" do
    patch :update, id: @briefing_frequency, briefing_frequency: { briefing_frequency: @briefing_frequency.briefing_frequency, name: @briefing_frequency.name }
    assert_redirected_to briefing_frequency_path(assigns(:briefing_frequency))
  end

  test "should destroy briefing_frequency" do
    assert_difference('BriefingFrequency.count', -1) do
      delete :destroy, id: @briefing_frequency
    end

    assert_redirected_to briefing_frequencies_path
  end
end
