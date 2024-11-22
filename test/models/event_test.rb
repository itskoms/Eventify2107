# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  date        :datetime
#  description :text
#  end_time    :datetime
#  location    :string
#  start_time  :datetime
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class EventTest < ActiveSupport::TestCase
  def setup
    @event = Event.new(
      title: "Sample Event",
      start_time: Time.current + 1.day,
      end_time: Time.current + 1.day + 2.hours,
      location: "Sample Location",
      date: Time.current + 2.days
    )
  end

  # Test validations
  test "should be valid with all attributes" do
    assert @event.valid?
  end

  test "should be invalid without a title" do
    @event.title = nil
    assert_not @event.valid?
    assert_includes @event.errors[:title], "can't be blank"
  end

  test "should be invalid without a start_time" do
    @event.start_time = nil
    assert_not @event.valid?
    assert_includes @event.errors[:start_time], "can't be blank"
  end

  test "should be invalid without an end_time" do
    @event.end_time = nil
    assert_not @event.valid?
    assert_includes @event.errors[:end_time], "can't be blank"
  end

  test "should be invalid without a location" do
    @event.location = nil
    assert_not @event.valid?
    assert_includes @event.errors[:location], "can't be blank"
  end

  test "should be invalid if date is in the past" do
    @event.date = Time.current - 1.day
    assert_not @event.valid?
    assert_includes @event.errors[:date], "must be in the future"
  end

  # Test associations
  test "should have one guest_list" do
    assert_respond_to @event, :guest_list
  end

  test "should have many guests" do
    assert_respond_to @event, :guests
  end
end
