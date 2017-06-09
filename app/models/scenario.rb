class Scenario < ActiveRecord::Base

  def long_name
    "#{season}-#{"%02d" % scenario_number}: #{name}"
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
