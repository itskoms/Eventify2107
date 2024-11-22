# == Schema Information
#
# Table name: guest_lists
#
#  id          :integer          not null, primary key
#  rsvp_status :string
#  event_id    :integer          not null
#  guest_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class GuestList < ApplicationRecord
    has_many :guests, dependent: :destroy
    belongs_to :event
end
