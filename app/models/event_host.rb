class EventHost < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :start_date, presence: true

  def end_date?
    !end_date.nil?
  end

  def active? (date = nil)
    if date.nil?
      date = Date.today
    end
    date_start = start_date.to_date
    if end_date?
      date_end = end_date.to_date
    else
      # No end date, so always in the future.
      date_end = Date.new(3000, 1, 1)
    end
    # Start date should never be nil, but never a bad thing to check
    if date_start.nil?
      date_start = Date.new(2000, 1, 1)
    end
    date.between?(date_start, date_end)
  end
end

