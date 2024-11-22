# == Schema Information
#
# Table name: organizers
#
#  id              :integer          not null, primary key
#  email           :string           default(""), not null
#  first_name      :string
#  last_name       :string
#  password_digest :string           default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Organizer < ApplicationRecord
    has_secure_password
    has_many :events

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
end
