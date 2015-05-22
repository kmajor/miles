require 'test_helper'

class SearchResultsControllerTest < ActionController::TestCase
  setup do
    @search_result = search_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create search_result" do
    assert_difference('SearchResult.count') do
      post :create, search_result: { airline_id: @search_result.airline_id, results: @search_result.results, search_id: @search_result.search_id }
    end

    assert_redirected_to search_result_path(assigns(:search_result))
  end

  test "should show search_result" do
    get :show, id: @search_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @search_result
    assert_response :success
  end

  test "should update search_result" do
    patch :update, id: @search_result, search_result: { airline_id: @search_result.airline_id, results: @search_result.results, search_id: @search_result.search_id }
    assert_redirected_to search_result_path(assigns(:search_result))
  end

  test "should destroy search_result" do
    assert_difference('SearchResult.count', -1) do
      delete :destroy, id: @search_result
    end

    assert_redirected_to search_results_path
  end
end
