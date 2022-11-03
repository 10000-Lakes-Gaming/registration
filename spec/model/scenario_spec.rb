# frozen_string_literal: true

require 'rails_helper'

describe Scenario, type: :model do
  fixtures :scenarios
  context '#id' do
    it 'scenario_one_five' do
      expect(scenarios(:scenario_one_five).id).to eq 150_161_699
    end
  end

  context '#tte_name' do
    # This is to check that we don't exceed 60 chars.
    it 'long scenario name is appropriately truncated' do
      scenario = scenarios(:long_name)
      name = scenario.tte_name

      expect(name).to eq 'PFS2 4-01: The near-death experience brought new... (1-4)'
      expect(name.length).to eq 57
    end

    it 'special_three_four is pretty short' do
      scenario = scenarios(:special_three_four)
      name = scenario.tte_name

      expect(name).to eq 'PFS 10-00: What a special (3-4)'
      expect(name.length).to eq 31
    end
  end
end
