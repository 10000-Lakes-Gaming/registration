require 'rails_helper'

describe ApplicationHelper do
  context '#optional_fee_list' do
    it 'returns 21 elements, starting with 0, ending with 100, by default' do
      fees = helper.optional_fee_list
      expect(fees.blank?).to be false
      expect(fees.size).to eq 21
      expect(fees.first).to be 0
      expect(fees.last).to be 100
    end

    it 'returns proper list of x + 1 elements with values by y, first being z' do
      elements = 15
      increment = 3
      starting = 10
      fees = helper.optional_fee_list(elements, increment, starting)
      expect(fees.size).to eq elements + 1
      expect(fees.first).to eq starting
      expect(fees.last).to eq( starting + (increment * elements))
    end
  end
end
