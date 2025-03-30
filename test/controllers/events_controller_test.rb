require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
     # Create a user with valid attributes
     @user = User.create!(
      first_name: "user",
      last_name: "name",
      email: "guest@example.com",
      password: "password"
    )

     # Create an event with valid attributes
     @event = Event.create!(
      title: "Test Event",
      start_date: DateTime.now + 1.day,  # Future date
      end_date: DateTime.now + 2.day,
      start_time: DateTime.now + 1.day + 2.hours,
      end_time: DateTime.now + 2.day + 4.hours,
      location: "Test Location",
      description: "Test Description",
      user_id: @user.id
    )

    post user_sessions_path, params: { email: @user.email, password: "password" }
    assert_response :redirect # Ensure login was successful
    follow_redirect!
  end


  test "should get index" do
    get events_url
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should get new" do
    get new_event_url
    assert_response :success
    assert_not_nil assigns(:event)
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_url, params: { event: { title: "Alice's Birthday Party",
      start_date: Time.now + 1.day,
      end_date: Time.now + 1.day + 3.hours,
      start_time: Time.now + 1.day + 2.hours,
      end_time: Time.now + 1.day + 5.hours,
      location: "Alice's House",
      user_id: @user.id,
      description: "A fun birthday party!" } }
    end

    assert_redirected_to event_url(Event.last)
    assert_equal "Event was successfully created.", flash[:notice]
  end

  test "should not create event with invalid data" do
    assert_no_difference("Event.count") do
      post events_url, params: { event: { title: "test" } }  # Invalid event params
    end
    assert_includes flash[:alert], "Failed to create event"
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
    assert_not_nil assigns(:event)
  end

  test "should update event" do
    patch event_url(@event), params: {
      event: {
        title: "Updated Title",
        description: @event.description,
        location: @event.location,
        start_date: @event.start_date,
        end_date: @event.end_date
      },
      start_hour: "2",
      start_minute: "00",
      start_period: "PM",
      end_hour: "4",
      end_minute: "00",
      end_period: "PM"
    }

    assert_redirected_to event_url(@event)
    assert_equal "Event was successfully updated.", flash[:notice]
    assert_equal "Updated Title", @event.reload.title
  end

  test "should not update event with invalid data" do
    patch event_url(@event), params: {
      event: {
        title: "",
        description: @event.description,
        location: @event.location,
        start_date: @event.start_date,
        end_date: @event.end_date
      },
      start_hour: "2",
      start_minute: "00",
      start_period: "PM",
      end_hour: "4",
      end_minute: "00",
      end_period: "PM"
    }

    assert_equal "Test Event", @event.title
    assert_template :edit
  end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
    assert_equal "Event was successfully deleted.", flash[:notice]
  end
end
