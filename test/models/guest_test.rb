# == Schema Information
#
# Table name: guests
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  first_name      :string
#  last_name       :string
#  party_size      :integer
#  password_digest :string           default(""), not null
#  phone           :string
#  event_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class GuestTest < ActiveSupport::TestCase
  def setup
    @guest = Guest.new(
      email: "test@example.com",
      first_name: "Test",
      last_name: "User",
      party_size: 2,
      password: "password123",
      password_confirmation: "password123",
      phone: "123-456-7890"
    )
  end

  # Test that a valid guest can be saved
  test "should be valid with all attributes" do
    assert @guest.valid?
  end

  # Test presence and uniqueness validations for email
  test "should require an email" do
    @guest.email = nil
    assert_not @guest.valid?
    assert_includes @guest.errors[:email], "can't be blank"
  end

  test "should require a unique email" do
    duplicate_guest = @guest.dup
    @guest.save
    assert_not duplicate_guest.valid?
    assert_includes duplicate_guest.errors[:email], "has already been taken"
  end

  # Test password validations
  test "should require a password" do
    @guest.password = nil
    assert_not @guest.valid?
    assert_includes @guest.errors[:password], "can't be blank"
  end

  test "password should have a minimum length" do
    @guest.password = "short"
    assert_not @guest.valid?
    assert_includes @guest.errors[:password], "is too short (minimum is 6 characters)"
  end

  # Test associations
  test "should have many guest lists" do
    assert_respond_to @guest, :guest_lists
  end

  test "should have many events through guest lists" do
    assert_respond_to @guest, :events
  end

  test "should have many gift registries" do
    assert_respond_to @guest, :gift_registries
  end

  test "should have many gifts through gift registries" do
    assert_respond_to @guest, :gifts
  end

  # Test `has_secure_password` functionality
  test "should authenticate with correct password" do
    @guest.save
    assert @guest.authenticate("password123")
  end

  test "should not authenticate with incorrect password" do
    @guest.save
    assert_not @guest.authenticate("wrongpassword")
  end
end
