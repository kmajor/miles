require 'test_helper'

class UnitedsControllerTest < ActionController::TestCase
  setup do
    @united = uniteds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:uniteds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create united" do
    assert_difference('United.count') do
      post :create, united: {  }
    end

    assert_redirected_to united_path(assigns(:united))
  end

  test "should show united" do
    get :show, id: @united
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @united
    assert_response :success
  end

  test "should update united" do
    patch :update, id: @united, united: {  }
    assert_redirected_to united_path(assigns(:united))
  end

  test "should destroy united" do
    assert_difference('United.count', -1) do
      delete :destroy, id: @united
    end

    assert_redirected_to uniteds_path
  end
end
