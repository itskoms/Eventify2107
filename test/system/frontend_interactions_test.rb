require "application_system_test_case"

class FrontendInteractionsTest < ApplicationSystemTestCase
  include Rails.application.routes.url_helpers

  setup do
    @user = users(:one)
    @event = events(:birthday_party)
    default_url_options[:host] = "localhost"
  end

  def sign_in_as(user)
    visit new_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Login"
    assert_text "Logged in successfully."
  end

  test "visiting the home page" do
    visit root_path
    assert_selector "h1", text: "Welcome to Eventify"
  end

  test "user sign in flow" do
    visit new_session_path
    assert_selector "h3", text: "Login"

    fill_in "Email", with: @user.email
    fill_in "Password", with: "password123"
    click_button "Login"

    assert_text "Logged in successfully."
  end

  test "event creation flow" do
    sign_in_as(@user)

    visit new_event_path
    assert_selector "h1", text: "Create a New Event"

    fill_in "event_title", with: "Test Event"
    fill_in "event_description", with: "Test Description"
    fill_in "event_location", with: "Test Location"

    # Fill in datetime fields with proper formatting
    select_date = Time.current + 1.day
    formatted_date = select_date.strftime("%Y-%m-%d")

    # Use execute_script to set the date value directly
    page.execute_script("document.getElementById('event_start_date').value = '#{formatted_date}'")
    page.execute_script("document.getElementById('event_end_date').value = '#{formatted_date}'")

    # Fill in time using select fields
    select "2", from: "event[start_hour]"
    select "00", from: "event[start_minute]"
    select "PM", from: "event[start_period]"

    select "4", from: "event[end_hour]"
    select "00", from: "event[end_minute]"
    select "PM", from: "event[end_period]"

    click_button "Create Event"

    # Wait for the redirect and verify we're on the show page
    assert_current_path %r{/events/\d+}

    # Verify event details are displayed
    assert_text "Test Event"
    assert_text "Test Description"
    assert_text "Test Location"
    assert_text "02:00 PM"
    assert_text "04:00 PM"
  end

  test "viewing existing event details" do
    sign_in_as(@user)
    visit event_path(@event)

    assert_text @event.title
    assert_text @event.description
    assert_text @event.location
  end

  test "responsive design" do
    visit root_path
    # Test mobile viewport
    page.driver.browser.manage.window.resize_to(375, 812) # iPhone X dimensions
    assert_selector ".navbar-toggler", visible: true

    # Test desktop viewport
    page.driver.browser.manage.window.resize_to(1920, 1080)
    assert_selector ".navbar-toggler", visible: false
  end

  test "calendar interaction" do
    sign_in_as(@user)
    visit events_path

    # Look for the calendar heading
    assert_selector ".card-header", text: "Event Calendar"

    # Verify existing event is shown
    assert_text @event.title

    # Test calendar navigation - using simple_calendar's navigation
    within(".simple-calendar") do
      click_link "Next"
    end
    assert_current_path %r{/events\?.*start_date.*}
  end

  test "editing an event" do
    sign_in_as(@user)
    visit event_path(@event)

    click_link "Edit"
    assert_selector "h1", text: "Edit Event"

    fill_in "event_title", with: "Updated Birthday Party"
    fill_in "event_description", with: "Updated celebration details"

    select_date = Time.current + 1.day
    formatted_date = select_date.strftime("%Y-%m-%d")

    # Use execute_script to set the date value directly
    page.execute_script("document.getElementById('event_start_date').value = '#{formatted_date}'")
    page.execute_script("document.getElementById('event_end_date').value = '#{formatted_date}'")

    click_button "Update Event"

    assert_current_path event_path(@event)
    assert_text "Updated Birthday Party"
    assert_text "Updated celebration details"
  end

  test "event filtering and organization" do
    sign_in_as(@user)
    visit events_path

    # Test event cards section
    assert_selector ".card", text: @event.title

    # Test calendar view
    within(".card", text: "Event Calendar") do
      assert_selector ".simple-calendar"
      assert_text @event.title
    end
  end
end
