require 'test_helper'

class SessionsOfTheDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sessions_of_the_day = sessions_of_the_days(:one)
  end

  test "should get index" do
    get sessions_of_the_days_url
    assert_response :success
  end

  test "should get new" do
    get new_sessions_of_the_day_url
    assert_response :success
  end

  test "should create sessions_of_the_day" do
    assert_difference('SessionsOfTheDay.count') do
      post sessions_of_the_days_url, params: { sessions_of_the_day: {  } }
    end

    assert_redirected_to sessions_of_the_day_url(SessionsOfTheDay.last)
  end

  test "should show sessions_of_the_day" do
    get sessions_of_the_day_url(@sessions_of_the_day)
    assert_response :success
  end

  test "should get edit" do
    get edit_sessions_of_the_day_url(@sessions_of_the_day)
    assert_response :success
  end

  test "should update sessions_of_the_day" do
    patch sessions_of_the_day_url(@sessions_of_the_day), params: { sessions_of_the_day: {  } }
    assert_redirected_to sessions_of_the_day_url(@sessions_of_the_day)
  end

  test "should destroy sessions_of_the_day" do
    assert_difference('SessionsOfTheDay.count', -1) do
      delete sessions_of_the_day_url(@sessions_of_the_day)
    end

    assert_redirected_to sessions_of_the_days_url
  end
end
