class Scenario < ActiveRecord::Base

  validates :system, :type_of, :season, :scenario_number, :name, :tier, :presence => true
  validates :scenario_number, presence: true, if: scenario?


  def long_name
    "#{system} #{season}-#{"%02d" % scenario_number}: #{name}"
  end

  def scenario?
    :type_of == 'Scenario'
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
