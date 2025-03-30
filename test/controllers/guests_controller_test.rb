require "test_helper"

class GuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Create test data instead of using fixtures
    @admin_user = User.create!(email: "admin@example.com", password: "password", first_name: "Admin", last_name: "User")
    @guest_user = User.create!(email: "guest@example.com", password: "password", first_name: "Guest", last_name: "User")

    @event = Event.create!(
      title: "Test Event",
      start_date: 1.day.from_now,
      end_date: 2.days.from_now,
      start_time: Time.current + 1.hour,
      end_time: Time.current + 2.hours,
      location: "Test Location",
      user: @admin_user
    )

    @guest = Guest.create!(
      user: @guest_user,
      event: @event,
      role: "guest",
      rsvp_status: "pending"
    )

    sign_in @admin_user
  end

  test "should get index" do
    get event_path(@event)
    assert_response :success
    assert_equal assigns(:guests), @event.guests
  end

  test "should create guest" do
    assert_difference("Guest.count", 1) do
      post event_guests_path(@event), params: {
        email: @guest_user.email,
        first_name: @guest_user.first_name,
        last_name: @guest_user.last_name,
        role: "guest",
        party_size: 1
      }
    end

    assert_redirected_to event_path(@event)
    assert_equal "Guest successfully created.", flash[:notice]
  end

  test "should destroy guest" do
    assert_difference("Guest.count", -1) do
      delete event_guest_path(@event, @guest)
    end

    assert_redirected_to event_path(@event)
  end


  test "should add guest to event" do
    assert_difference "@event.guests.count", 1 do
      post add_guest_event_url(@event), params: { email: "new_guest@example.com", first_name: "John", last_name: "Doe" }
    end

    assert_redirected_to edit_event_path(@event)
    follow_redirect!
    assert_equal "Guest was successfully added.", flash[:notice]
  end

  test "should not add invalid guest to event" do
    # Attempt to add a guest with an empty email
    assert_no_difference("Guest.count") do
      post event_guests_path(@event), params: { email: "", first_name: "John", last_name: "Doe" }
    end
    assert_redirected_to @event
    assert_equal "Failed to create guest: Email can't be blank", flash[:alert]

    # Attempt to add a guest with missing first_name
    assert_no_difference("Guest.count") do
      post event_guests_path(@event), params: { email: "new_guest@example.com", first_name: "", last_name: "Doe" }
    end
    assert_redirected_to @event
    assert_equal "Failed to create guest: First name can't be blank", flash[:alert]

    # Attempt to add a guest with missing last_name
    assert_no_difference("Guest.count") do
      post event_guests_path(@event), params: { email: "new_guest@example.com", first_name: "John", last_name: "" }
    end
    assert_redirected_to @event
    assert_equal "Failed to create guest: Last name can't be blank", flash[:alert]
  end

  private

  def sign_in(user)
    post user_sessions_path, params: { email: user.email, password: "password" }
  end

  def sign_out(user)
    delete destroy_user_session_path
  end
end
