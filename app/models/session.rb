class Session < ActiveRecord::Base
  belongs_to :event
  has_many :tables

  def timeslot
    self.start.strftime("%a %H:%M to ") + self.end.strftime("%a %H:%M")
  end
end
