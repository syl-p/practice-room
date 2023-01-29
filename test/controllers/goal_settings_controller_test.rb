require "test_helper"

class GoalSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get goal_settings_new_url
    assert_response :success
  end

  test "should get create" do
    get goal_settings_create_url
    assert_response :success
  end

  test "should get update" do
    get goal_settings_update_url
    assert_response :success
  end

  test "should get edit" do
    get goal_settings_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get goal_settings_destroy_url
    assert_response :success
  end
end
