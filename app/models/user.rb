# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           default(""), not null
#  first_name      :string
#  last_name       :string
#  phone_number    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    # Secure password handling (includes password hashing and authentication methods)
    has_secure_password
  
    # Associations
    has_many :guests, dependent: :destroy
    
    # Events where the user is an admin (via the guest association)
    has_many :events_as_admin, -> { where(guests: { role: "admin" }) }, through: :guests, source: :event
    
    # Events where the user is a guest (via the guest association)
    has_many :events_as_guest, -> { where(guests: { role: "guest" }) }, through: :guests, source: :event
  
    # A user can create many events (as the creator of the event)
    has_many :created_events, class_name: "Event", foreign_key: "creator_id", dependent: :destroy
  
    # Validations
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true
end
  