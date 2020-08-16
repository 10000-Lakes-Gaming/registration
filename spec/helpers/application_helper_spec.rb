require 'rails_helper'

describe ApplicationHelper do
  fixtures :events
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
      expect(fees.last).to eq(starting + (increment * elements))
    end
  end

  context '#self_select_allowed?' do
    before(:each) do
      @event = events(:my_event)
    end

    it 'if event is false, then it should be false' do
      @event.gm_self_select = false
      expect(helper.self_select_allowed?).to be false
    end

    it 'if event is true, then it should be true if ANY table is set to true' do
      @event.gm_self_select = true
      expect(helper.self_select_allowed?).to be true
    end

    it 'if event is true, then it should be falke if all tables are set to false' do
      @event.gm_self_select = true
      @event.tables.each { |table| table.gm_self_select = false }
      expect(helper.self_select_allowed?).to be false
    end
  end
end
