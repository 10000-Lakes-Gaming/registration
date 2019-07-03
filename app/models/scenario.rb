class Scenario < ActiveRecord::Base

  validates :game_system, :type_of, :name, :tier, :presence => true
  validates :scenario_number, presence: true, if: :scenario_number_needed?
  validates :season, presence: true, if: :season_needed?

  # @type_list = ['Scenario', 'Quest', 'Module', 'Adventure Path', 'ACG']

  def long_name
    if game_system == 'Other'
      name
    else
      if scenario?
        "#{game_system} #{season}-#{"%02d" % scenario_number}: #{name}"
      elsif quest?
        "#{game_system} Season #{season} Quests: #{name}"
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

  def replayable_display
    if self.evergreen?
      if "PFS".eql? self.game_system
        "Evergreen"
      else
        "Replayable"
      end
    end
  end

  def self.to_csv ()
    attributes = %w{game_system season number name tier description author type hard_mode pregen_only retired replayable url}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |scenario|
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
    copy
  end

  def <=>(scenario)
    game = self.game_system.to_s
    other_game = scenario.game_system.to_s
    sorted = game <=> other_game

    if sorted == 0
      season = self.season.to_s
      other = scenario.season.to_s
      sorted = (season <=> other) * -1
      if sorted == 0
        my_number = self.scenario_number.to_i
        other_number = scenario.scenario_number.to_i
        sorted = my_number <=> other_number
        if sorted == 0
          # this may be an issue, as tiers are not easily sortable
          me = self.tier.to_s
          you = scenario.tier.to_s
          sorted = me <=> you
          if sorted == 0
            me = self.name.to_s
            you = scenario.name.to_s
            sorted = me <=> you
          end
        end
      end
    end
    sorted
  end

end
