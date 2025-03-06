# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  start_date  :datetime         not null
#  end_date    :datetime         not null
#  description :text
#  end_time    :datetime         not null
#  location    :string           not null
#  start_time  :datetime         not null
#  title       :string           not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Event < ApplicationRecord
  # Associations
  has_many :guests, dependent: :destroy
  belongs_to :user

  # Validations
  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true

  # Custom validations
  validate :date_must_be_in_the_future
  validate :end_date_be_equal_to_or_after_start_date
  private

  # Custom validation to ensure the start date is in the future
  def date_must_be_in_the_future
    if start_date.present? && start_date < Time.current
      errors.add(:start_date, "must be in the future")
    end
  end

  # Custom validation to ensure the end date is after the start date
  def end_date_be_equal_to_or_after_start_date
    if end_date.present? && end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
