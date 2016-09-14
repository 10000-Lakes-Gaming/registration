class Session < ActiveRecord::Base
  belongs_to :event
  has_many :tables

  def long_name
    self.name + " " + self.timeslot
  end

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

  def players_count
    players.length
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

  def gm_count
    gms.length
  end

  def total_max_players
    total_max_players = 0
    self.tables.each do |table|
      unless table.raffle?
        total_max_players = total_max_players + table.max_players
      end
    end
    total_max_players
  end

  def total_gms_needed
    total_max_gms = 0

    self.tables.each do |table|
      if table.raffle?
        total_max_gms = total_max_gms + table.game_masters.length
      else
        total_max_gms = total_max_gms + table.gms_needed
      end
    end
    total_max_gms
  end


  def <=> (other)
    sort = self.start <=> other.start
    if sort == 0
      sort = self.end <=> other.end
    end
    if sort == 0
      sort = self.long_name <=> other.long_name
    end
    sort
  end
end
