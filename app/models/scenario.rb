class Scenario < ActiveRecord::Base

  def long_name
    "#{season}-#{"%02d" % scenario_number}: #{name}"
  end
end
