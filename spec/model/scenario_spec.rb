# frozen_string_literal: true

require 'rails_helper'

describe Scenario, type: :model do
  fixtures :scenarios
  context '#id' do
    it 'scenario_one_five' do
      expect(scenarios(:scenario_one_five).id).to eq 150_161_699
    end
  end
end
