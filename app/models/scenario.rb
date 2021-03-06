# frozen_string_literal: true

class Scenario < ActiveRecord::Base
  # TODO: Convert all of the naked strings into constants
  validates :game_system, :type_of, :name, presence: true
  validates :scenario_number, presence: true, if: :scenario_number_needed?
  validates :season, presence: true, if: :season_needed?
  validates :tier, presence: true, if: :tier_needed?

  # TODO: Use constants instead of these strings
  TYPES = ['Scenario', 'Bounty', 'Quest', 'Module', 'Adventure Path', 'ACG', 'Other'].freeze
  SYSTEMS = %w[PFS2 SFS ACG Other PFS Playtest].freeze

  def group
    "#{game_system} Season #{season} #{type_of}"
  end

  def long_name
    if game_system == 'Other'
      name
    elsif scenario?
      "#{game_system} #{'%02d' % season}-#{'%02d' % scenario_number}: #{name}"
    elsif quest?
      if 'PFS2'.eql? game_system
        "#{game_system} Quest #{scenario_number}: #{name}"
      else
        "#{game_system} Season #{'%02d' % season} Quest: #{name}"
      end
    elsif bounty?
      # May have to add season if they add this in the future
      "#{game_system} Bounty #{scenario_number}: #{name}"
    elsif AP?
      "#{game_system} AP #{'%d' % scenario_number}: #{name}"
    else
      "#{game_system} #{name}"
    end
  end

  def short_name
    if scenario?
      "#{game_system} #{season}-#{'%02d' % scenario_number}"
    elsif AP?
      "#{game_system} AP #{'%d' % scenario_number}"
    else
      "#{game_system} #{name}"
    end
  end

  def scenario?
    type_of == 'Scenario'
  end

  def quest?
    type_of == 'Quest'
  end

  def bounty?
    type_of == 'Bounty'
  end

  def other_system?
    game_system == 'Other'
  end

  def opf_type?
    %w[PFS PFS2 SFS].include? game_system
  end

  # noinspection RubyInstanceMethodNamingConvention
  def AP?
    type_of == 'Adventure Path'
  end

  def season_needed?
    scenario? || quest?
  end

  def scenario_number_needed?
    scenario? || self.AP?
  end

  def tier_needed?
    !%w[ACG Other].include? game_system
  end

  def headquarters?
    tier.eql? 'HQ'
  end

  def replayable_display
    if evergreen?
      if 'PFS'.eql? game_system
        'Evergreen'
      else
        'Replayable'
      end
    end
  end

  def self.to_csv(scenario_list)
    attributes = %w[game_system season number name tier description author type hard_mode pregen_only retired
                    replayable url]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      scenario_list.each do |scenario|
        csv << [scenario.game_system, scenario.season, scenario.scenario_number, scenario.name, scenario.tier,
                scenario.description, scenario.author, scenario.type_of, scenario.hard_mode, scenario.pregen_only,
                scenario.retired, scenario.evergreen, scenario.paizo_url]
      end
    end
  end

  def copy
    copy = Scenario.new
    copy.type_of = type_of
    copy.season = season
    copy.scenario_number = scenario_number
    copy.name = name
    copy.description = description
    copy.author = author
    copy.paizo_url = paizo_url
    copy.hard_mode = hard_mode
    copy.pregen_only = pregen_only
    copy.tier = tier
    copy.retired = retired
    copy.game_system = game_system
    copy.evergreen = evergreen
    copy.catalog_number = catalog_number
    copy
  end

  def <=>(other)
    # HQ precedence
    unless headquarters? && other.headquarters?
      if headquarters?
        return 1
      elsif other.headquarters?
        return -1
      end
    end
    # sort out "other" to bottom
    unless other_system? && other.other_system?
      if other_system?
        return 1
      elsif other.other_system?
        return -1
      end
    end

    if game_system.eql? other.game_system
      if type_of.nil?
        1
      elsif other.type_of.nil?
        -1
      elsif type_of.eql? other.type_of
        long_name <=> other.long_name
      else
        TYPES.find_index(type_of) <=> TYPES.find_index(other.type_of)
      end
    else
      SYSTEMS.find_index(game_system) <=> SYSTEMS.find_index(other.game_system)
    end
  end
end
