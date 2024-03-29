# frozen_string_literal: true

class Session < ActiveRecord::Base # rubocop:disable Metrics/ClassLength
  belongs_to :event
  has_many :tables
  delegate :prereg_ends, to: :event
  delegate :prereg_closed?, to: :event

  def reload
    # Clear memoized values
    @in_person_regular_tables = nil
    @in_person_premium_tables = nil
    @online_premium_tables = nil
    @online_regular_tables = nil
    super
  end

  TIMESLOT_DATE_FORMAT = '%a %H:%M %Z'
  DATETIME_FORMAT = '%B %d, %Y %H:%M %Z'
  DATE_FORMAT = '%B %d, %Y'

  def long_name
    "#{name} - #{timeslot}"
  end

  def timeslot
    "#{start.strftime(TIMESLOT_DATE_FORMAT)} to #{self.end.strftime(TIMESLOT_DATE_FORMAT)}"
  end

  def session_time_minutes
    seconds_diff = (start - self.end).to_i.abs
    (seconds_diff / 3600).to_i * 60
  end

  def formatted_start
    start.strftime(DATETIME_FORMAT)
  end

  def formatted_end
    self.end.strftime(DATETIME_FORMAT)
  end

  def player_tables
    tables.reject(&:headquarters?)
  end

  def player_tables?
    player_tables.any?
  end

  def in_person_all_tables
    premium = in_person_premium_tables
    regular = in_person_regular_tables
    if premium.nil? && regular.nil?
      []
    elsif premium.nil?
      regular
    elsif regular.nil?
      premium
    else
      premium.concat(regular)
    end
  end

  def in_person_premium_tables
    unless @in_person_premium_tables
      @in_person_premium_tables = tables.select { |table| !table.online? && table.premium? }
      @in_person_premium_tables = @in_person_premium_tables.reject(&:headquarters?)
      @in_person_premium_tables.sort_by { |table| [table.scenario] }
    end
    @in_person_premium_tables
  end

  def in_person_regular_tables
    unless @in_person_regular_tables
      @in_person_regular_tables = tables.select { |table| !table.online? && !table.premium? }
      @in_person_regular_tables = @in_person_regular_tables.reject(&:headquarters?)
      @in_person_regular_tables.sort_by { |table| [table.scenario] }
    end
    @in_person_regular_tables
  end

  def online_all_tables
    premium = online_premium_tables
    regular = online_regular_tables
    if premium.nil? && regular.nil?
      []
    elsif premium.nil?
      regular
    elsif regular.nil?
      premium
    else
      premium.concat(regular)
    end
  end

  def online_premium_tables
    unless @online_premium_tables
      @online_premium_tables = tables.select { |table| table.online? && table.premium? }
      @online_premium_tables = @online_premium_tables.reject(&:headquarters?)
      @online_premium_tables.sort_by { |table| [table.scenario] }
    end
    @online_premium_tables
  end

  def online_regular_tables
    unless @online_regular_tables
      @online_regular_tables = tables.select { |table| table.online? && !table.premium? }
      @online_regular_tables = @online_regular_tables.reject(&:headquarters?)
      @online_regular_tables.sort_by { |table| [table.scenario] }
    end
    @online_regular_tables
  end

  def headquarters_tables
    @headquarters_tables ||= tables.select(&:headquarters?)
  end

  def premium_tables?
    online_premium_tables.any? || in_person_premium_tables.any?
  end

  def online_regular_tables?
    online_regular_tables.any?
  end

  def in_person_regular_tables?
    in_person_regular_tables.any?
  end

  def online_premium_tables?
    online_premium_tables.any?
  end

  def in_person_premium_tables?
    in_person_premium_tables.any?
  end

  def online_tables?
    online_regular_tables.any? || online_premium_tables.any?
  end

  def headquarters_tables?
    headquarters_tables.any?
  end

  def allow_hq_reg?
    headquarters_tables.any? { |table| table.gm_self_select? && !table.disabled? }
  end

  def only_hq?
    headquarters_tables? && player_tables.empty?
  end

  def premium_tables
    premium_tables = tables.select(&:premium?)
    premium_tables.sort_by { |table| [table.scenario] }
  end

  def nonpremium_tables
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

  def player_tables
    return @player_tables if @player_tables.present?

    @player_tables = {}
    tables.each do |table|
      table.game_masters.each do |gm|
        user = gm.user_event.user
        puts "Adding GM #{user.name} with #{gm.short_name}"
        @player_tables[user] = gm
      end
      table.registration_tables.each do |player|
        user = player.user_event.user
        puts "Adding Player #{user.name} with #{player.short_name}"
        @player_tables[player.user_event.user] = player
      end
    end
    @player_tables
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
      total_max_gms +=
        if table.raffle?
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
