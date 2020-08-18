class Scenario < ActiveRecord::Base
  # TODO: Convert all of the naked strings into constants
  validates :game_system, :type_of, :name, :presence => true
  validates :scenario_number, presence: true, if: :scenario_number_needed?
  validates :season, presence: true, if: :season_needed?
  validates :tier, presence: true, if: :tier_needed?

  # TODO: Use constants instead of these strings
  TYPES = ['Scenario', 'Bounty', 'Quest', 'Module', 'Adventure Path', 'ACG', 'Other']
  SYSTEMS = %w[PFS2 SFS ACG Other PFS Playtest]

  def group
    "#{game_system} Season #{season} #{type_of}"
  end

  def long_name
    if game_system == 'Other'
      name
    else
      if scenario?
        "#{game_system} #{"%02d" % season}-#{"%02d" % scenario_number}: #{name}"
      elsif quest?
        if 'PFS2'.eql? self.game_system
          "#{game_system} Quest #{scenario_number}: #{name}"
        else
          "#{game_system} Season #{"%02d" % season} Quest: #{name}"
        end
      elsif bounty?
        # May have to add season if they add this in the future
        "#{game_system} Bounty #{scenario_number}: #{name}"
      elsif AP?
        "#{game_system} AP #{"%d" % scenario_number}: #{name}"
      else
        "#{game_system} #{name}"
      end
    end
  end

  def short_name
    if scenario?
      "#{game_system} #{season}-#{"%02d" % scenario_number}"
    elsif quest?
      "#{game_system} #{name}"
    elsif AP?
      "#{game_system} AP #{"%d" % scenario_number}"
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

  # noinspection RubyInstanceMethodNamingConvention
  def AP?
    type_of == 'Adventure Path'
  end

  def season_needed?
    self.scenario? || self.quest?
  end

  def scenario_number_needed?
    self.scenario? || self.AP?
  end

  def tier_needed?
    !['ACG', 'Other'].include? self.game_system
  end

  def headquarters?
    tier.eql? 'HQ'
  end

  def replayable_display
    if self.evergreen?
      if "PFS".eql? self.game_system
        "Evergreen"
      else
        "Replayable"
      end
    end
  end

  def self.to_csv (scenario_list)
    attributes = %w{game_system season number name tier description author type hard_mode pregen_only retired replayable url}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      scenario_list.each do |scenario|
        csv << [scenario.game_system, scenario.season, scenario.scenario_number, scenario.name, scenario.tier, scenario.description, scenario.author, scenario.type_of, scenario.hard_mode, scenario.pregen_only, scenario.retired, scenario.evergreen, scenario.paizo_url]
      end
    end
  end

  def copy ()
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
  end

  def <=>(scenario)
    # HQ precedence
    unless self.headquarters? && scenario.headquarters?
      if self.headquarters?
        return 1
      elsif scenario.headquarters?
        return -1
      end
    end
    # sort out "other" to bottom
    unless self.other_system? && scenario.other_system?
      if self.other_system?
        return 1
      elsif scenario.other_system?
        return -1
      end
    end

    if self.game_system.eql? scenario.game_system
      if self.type_of.nil?
        return 1
      elsif scenario.type_of.nil?
        return -1
      else
        if type_of.eql? scenario.type_of
          long_name <=> scenario.long_name
        else
          TYPES.find_index(self.type_of) <=> TYPES.find_index(scenario.type_of)
        end
      end
    else
      SYSTEMS.find_index(self.game_system) <=> SYSTEMS.find_index(scenario.game_system)
    end
  end
end
