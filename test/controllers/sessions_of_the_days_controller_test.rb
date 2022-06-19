require 'test_helper'

class SessionsOfTheDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @practices_of_the_day = practices_of_the_days(:one)
  end

  test "should get index" do
    get practices_of_the_days_url
    assert_response :success
  end

  test "should get new" do
    get new_practices_of_the_day_url
    assert_response :success
  end

  test "should create practices_of_the_day" do
    assert_difference('SessionsOfTheDay.count') do
      post practices_of_the_days_url, params: { practices_of_the_day: {  } }
    end

    assert_redirected_to practices_of_the_day_url(SessionsOfTheDay.last)
  end

  test "should show practices_of_the_day" do
    get practices_of_the_day_url(@practices_of_the_day)
    assert_response :success
  end

  test "should get edit" do
    get edit_practices_of_the_day_url(@practices_of_the_day)
    assert_response :success
  end

  test "should update practices_of_the_day" do
    patch practices_of_the_day_url(@practices_of_the_day), params: { practices_of_the_day: {  } }
    assert_redirected_to practices_of_the_day_url(@practices_of_the_day)
  end

  test "should destroy practices_of_the_day" do
    assert_difference('SessionsOfTheDay.count', -1) do
      delete practices_of_the_day_url(@practices_of_the_day)
    end

    assert_redirected_to practices_of_the_days_url
  end
end
