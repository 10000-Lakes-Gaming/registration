# frozen_string_literal: true

class ScenarioGroup
  attr_accessor :group

  def scenarios
    @scenarios ||= []
  end

  def <=>(other)
    group <=> other.group
  end
end
