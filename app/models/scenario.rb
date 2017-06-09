class Scenario < ActiveRecord::Base

  validates :system, :type, :season, :scenario_number, :name, :tier, :presence => true

  def long_name
    "#{system} #{season}-#{"%02d" % scenario_number}: #{name}"
  end


  def <=>(scenario)
    sorted = (self.season <=> scenario.season) * -1
    if sorted == 0
      sorted = self.scenario_number <=> scenario.scenario_number
      if sorted == 0
        sorted = self.name <=> scenario.name
      end
    end
    sorted
  end
end
