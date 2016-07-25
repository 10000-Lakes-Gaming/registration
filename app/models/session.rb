class Session < ActiveRecord::Base
  belongs_to :event
  has_many :tables

  def timeslot
    self.start.strftime("%a %H:%M to ") + self.end.strftime("%a %H:%M")
  end

  def players
    players = []
    self.tables.each do |table|
      table.registration_tables.each do |reg|
        players.push reg.user_event.user
      end
    end
    players
  end

  def gms
    gms = []
    self.tables.each do |table|
      table.game_masters.each do |gm|
        gms.push gm.user_event.user
      end
    end
    gms
  end
end
