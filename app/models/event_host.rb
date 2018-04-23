class EventHost < ApplicationRecord
  belongs_to :user
  belongs_to :event

  def active?
    end_date.to_date.future?
  end
end
