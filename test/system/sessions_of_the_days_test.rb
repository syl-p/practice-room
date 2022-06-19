require "application_system_test_case"

class SessionsOfTheDaysTest < ApplicationSystemTestCase
  setup do
    @practices_of_the_day = practices_of_the_days(:one)
  end

  test "visiting the index" do
    visit practices_of_the_days_url
    assert_selector "h1", text: "Sessions Of The Days"
  end

  test "creating a Sessions of the day" do
    visit practices_of_the_days_url
    click_on "New Sessions Of The Day"

    click_on "Create Sessions of the day"

    assert_text "Sessions of the day was successfully created"
    click_on "Back"
  end

  test "updating a Sessions of the day" do
    visit practices_of_the_days_url
    click_on "Edit", match: :first

    click_on "Update Sessions of the day"

    assert_text "Sessions of the day was successfully updated"
    click_on "Back"
  end

  test "destroying a Sessions of the day" do
    visit practices_of_the_days_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sessions of the day was successfully destroyed"
  end
end
