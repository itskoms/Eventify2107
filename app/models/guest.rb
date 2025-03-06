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
class Guest < ApplicationRecord
    # Associations
    belongs_to :event
    belongs_to :user 
  
    # Enum for role - defines the possible roles a guest can have
    enum role: [ :guest, :admin ]
  
    # Enum for RSVP status - defines the possible RSVP statuses for a guest
    enum rsvp_status: [ :pending, :accepted, :declined ]
  end
  