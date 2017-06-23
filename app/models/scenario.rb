class Scenario < ActiveRecord::Base

  validates :system, :type_of, :name, :tier, :presence => true
  validates :scenario_number, presence: true, if: :scenario_number_needed?
  validates :season, presence: true, if: :season_needed?

  # @type_list = ['Scenario', 'Quest', 'Module', 'Adventure Path', 'ACG']

  def long_name
    if scenario?
      "#{system} #{season}-#{"%02d" % scenario_number}: #{name}"
    elsif quest?
      "#{system} Season #{season} Quests: #{name}"
    elsif AP?
      "#{system} AP #{"%d" % scenario_number}: #{name}"
    else
      "#{system} #{name}"
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
    sorted = (self.season <=> scenario.season) * -1
    if sorted == 0
      my_number    = self.scenario_number.to_s
      other_number = scenario.scenario_number.to_s
      sorted       = my_number <=> other_number
      if sorted == 0
        sorted = self.name <=> scenario.name
      end
    end
    sorted
  end
end
