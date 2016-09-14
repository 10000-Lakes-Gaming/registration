class Scenario < ActiveRecord::Base

  def long_name
    "#{season}-#{"%02d" % scenario_number}: #{name}"
  end


  def <=>(scenario)
    sorted = self.season <=> scenario.season
    if sorted != 0
      sorted *= -1
    else
      sorted = self.scenario_number <=> scenario.scenario_number
      if sorted == 0
        sorted = self.name <=> scenario.name
      end
    end
    sorted
  end
end
