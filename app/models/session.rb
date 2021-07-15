# frozen_string_literal: true

class Session < ActiveRecord::Base
  belongs_to :event
  has_many :tables
  delegate :prereg_ends, to: :event
  delegate :prereg_closed?, to: :event

  TIMESLOT_DATE_FORMAT = '%a %H:%M %Z'
  DATETIME_FORMAT = '%B %d, %Y %H:%M %Z'

  def long_name
    "#{name} - #{timeslot}"
  end

  def timeslot
    "#{start.strftime(TIMESLOT_DATE_FORMAT)} to #{self.end.strftime(TIMESLOT_DATE_FORMAT)}"
  end

  def formatted_start
    start.strftime(DATETIME_FORMAT)
  end

  def formatted_end
    self.end.strftime(DATETIME_FORMAT)
  end

  def premium_tables?
    tables.any?(&:premium?)
  end

  def premium_tables
    # noinspection RubyArgCount
    premium_tables = tables.select(&:premium?)
    premium_tables.sort_by { |table| [table.scenario] }
  end

  def nonpremium_tables
    # noinspection RubyArgCount
    nonpremium_tables = tables.reject(&:premium?)
    nonpremium_tables.sort_by { |table| [table.scenario] }
  end

  def participants
    participants = players.dup
    participants.concat gms.dup
    participants.sort
  end

  def players
    players = []
    tables.each do |table|
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
    tables.each do |table|
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
    tables.each do |table|
      total_max_players += table.max_players unless table.raffle?
    end
    total_max_players
  end

  def total_gms_needed
    total_max_gms = 0

    tables.each do |table|
      total_max_gms += if table.raffle?
                         table.game_masters.length
                       else
                         table.gms_needed
                       end
    end
    total_max_gms
  end

  def <=>(other)
    sort = start <=> other.start
    sort = self.end <=> other.end if sort.zero?
    sort = long_name <=> other.long_name if sort.zero?
    sort
  end
end
