# == Schema Information
#
# Table name: guests
#
#  id          :integer          not null, primary key
#  role        :string           default(NULL)
#  rsvp_status :string           default(NULL)
#  party_size  :integer          default(1)
#  event_id    :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class GuestTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "johndoe@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    @event = Event.create!(
      title: "Sample Event",
      start_date: Time.current + 1.day,
      end_date: Time.current + 2.days,
      start_time: Time.current + 1.day + 2.hours,
      end_time: Time.current + 1.day + 4.hours,
      location: "Sample Location",
      description: "Sample Description",
      user_id: @user.id
    )

    @guest = Guest.new(
      user: @user,
      event: @event,
      role: "guest",
      rsvp_status: "pending",
      party_size: 1
    )
  end

  test "should be valid with all attributes" do
    assert @guest.valid?
  end

  test "should require a user" do
    @guest.user = nil
    assert_not @guest.valid?
    assert_includes @guest.errors[:user], "must exist"
  end

  test "should require an event" do
    @guest.event = nil
    assert_not @guest.valid?
    assert_includes @guest.errors[:event], "must exist"
  end

  test "should have a default rsvp_status of pending" do
    new_guest = Guest.new(user: @user)
    assert_equal "pending", @guest.rsvp_status
  end

  test "should require a valid role" do
    assert_raises(ArgumentError) { @guest.role = "invalid_role" }
  end

  test "should require a valid rsvp_status" do
    @guest.rsvp_status = "invalid_status"
    assert_not @guest.valid?
    assert_includes @guest.errors[:rsvp_status], "is not included in the list"
  end
end
