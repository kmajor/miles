require 'test_helper'

class AnalystRecordsControllerTest < ActionController::TestCase
  setup do
    @analyst_record = analyst_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:analyst_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create analyst_record" do
    assert_difference('AnalystRecord.count') do
      post :create, analyst_record: { analyst_id: @analyst_record.analyst_id, game_date: @analyst_record.game_date, line_source: @analyst_record.line_source, matchup: @analyst_record.matchup, posted_time: @analyst_record.posted_time, result: @analyst_record.result, selection: @analyst_record.selection, sport_type: @analyst_record.sport_type }
    end

    assert_redirected_to analyst_record_path(assigns(:analyst_record))
  end

  test "should show analyst_record" do
    get :show, id: @analyst_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @analyst_record
    assert_response :success
  end

  test "should update analyst_record" do
    patch :update, id: @analyst_record, analyst_record: { analyst_id: @analyst_record.analyst_id, game_date: @analyst_record.game_date, line_source: @analyst_record.line_source, matchup: @analyst_record.matchup, posted_time: @analyst_record.posted_time, result: @analyst_record.result, selection: @analyst_record.selection, sport_type: @analyst_record.sport_type }
    assert_redirected_to analyst_record_path(assigns(:analyst_record))
  end

  test "should destroy analyst_record" do
    assert_difference('AnalystRecord.count', -1) do
      delete :destroy, id: @analyst_record
    end

    assert_redirected_to analyst_records_path
  end
end
