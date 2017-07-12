class Scenario < ActiveRecord::Base

  validates :game_system, :type_of, :name, :tier, :presence => true
  validates :scenario_number, presence: true, if: :scenario_number_needed?
  validates :season, presence: true, if: :season_needed?

  # @type_list = ['Scenario', 'Quest', 'Module', 'Adventure Path', 'ACG']

  def long_name
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


  def <=>(scenario)
    game       = self.game_system.to_s
    other_game = scenario.game_system.to_s
    sorted     = game <=> other_game

    if sorted == 0
      season = self.season.to_s
      other  = scenario.season.to_s
      sorted = (season <=> other) * -1
      if sorted == 0
        my_number    = self.scenario_number.to_i
        other_number = scenario.scenario_number.to_i
        sorted       = my_number <=> other_number
        if sorted == 0
          me  = self.tier.to_s
          you = scenario.tier.to_s
          sorted = me <=> you
          if  sorted == 0
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
