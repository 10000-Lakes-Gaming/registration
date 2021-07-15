class EventHost < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :start_date, presence: true
  validate :end_date_after_start_date?

  def end_date_after_start_date?
    if end_date?
      if end_date < start_date
        errors.add :end_date, "must be after start date"
      end
    end
  end

  def formatted_start_date
    self.start_date&.strftime(Session::DATETIME_FORMAT)
  end

  def formatted_end_date
    self.start_date&.strftime(Session::DATETIME_FORMAT)
  end

  def end_date?
    !end_date.nil?
  end

  def active? (date = Date.today)
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

