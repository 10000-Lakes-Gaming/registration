class Scenario < ActiveRecord::Base

  def long_name
    "#{season}-#{scenario_number}: #{name}"
  end
end
