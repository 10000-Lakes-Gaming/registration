require 'rails_helper'

describe Table do
  fixtures :all

  context 'Validation' do
    it 'table cannot be online unless event.online?' do
      session = sessions(:morning)
      scenario = scenarios(:scenario_one_five)

      table = Table.new
      table.scenario = scenario
      table.session = session
      table.gms_needed = 1
      table.max_players = 6

      table.online = true
      table.save
      expect(table.errors[:online]).to_not be_empty
    end

    it 'table MUST be online unless event.in_person?' do
      session = sessions(:other_session)
      scenario = scenarios(:scenario_one_five)

      table = Table.new
      table.scenario = scenario
      table.session = session
      table.gms_needed = 1
      table.max_players = 6

      table.online = false
      table.save
      expect(table.errors[:online]).to_not be_empty
    end
  end

  it 'table MUST have a location if online' do
    session = sessions(:other_session)
    scenario = scenarios(:scenario_one_five)

    table = Table.new
    table.scenario = scenario
    table.session = session
    table.gms_needed = 1
    table.max_players = 6

    table.online = true
    table.save
    expect(table.errors[:location]).to_not be_empty
  end

  it 'If table is online, it can have no more than 1 GM' do
    session = sessions(:other_session)
    scenario = scenarios(:scenario_one_five)

    table = Table.new
    table.scenario = scenario
    table.session = session
    table.gms_needed = 2
    table.max_players = 12

    table.online = true
    table.save
    expect(table.errors[:gms_needed]).to_not be_empty
  end

  it 'If table is online, it can have no more than 6 Players' do
    session = sessions(:other_session)
    scenario = scenarios(:scenario_one_five)

    table = Table.new
    table.scenario = scenario
    table.session = session
    table.gms_needed = 1
    table.max_players = 12

    table.online = true
    table.save
    expect(table.errors[:max_players]).to_not be_empty
  end
  context 'seats_available?' do
    it 'full table will return false' do
      table = tables(:full)
      expect(table.seats_available?).to be false
    end

    it 'Table one will return true' do
      table = tables(:one)
      expect(table.seats_available?).to be true
    end
  end

  context 'overlap?' do
    it 'quest_one overlaps table one' do
      one = tables(:one)
      quest = tables(:quest_one_table)

      expect(quest.overlaps?(one)).to be true
      expect(one.overlaps?(quest)).to be true
    end

    it 'quest_two overlaps table one' do
      one = tables(:one)
      quest = tables(:quest_two_table)

      expect(one.overlaps?(quest)).to be true
      expect(quest.overlaps?(one)).to be true
    end

    it 'quest_three overlaps table one' do
      one = tables(:one)
      quest = tables(:quest_three_table)

      expect(one.overlaps?(quest)).to be true
      expect(quest.overlaps?(one)).to be true
    end

    it 'quest_four doesn\'t overlap table one' do
      one = tables(:one)
      quest = tables(:quest_four_table)

      expect(one.overlaps?(quest)).to be false
      expect(quest.overlaps?(one)).to be false
    end

    it 'one does overlap table one' do
      one = tables(:one)

      expect(one.overlaps?(one)).to be true
    end

    it 'one does not overlap table premium_2' do
      one = tables(:one)
      premium_2 = tables(:premium_2)

      expect(one.overlaps?(premium_2)).to be false
      expect(premium_2.overlaps?(one)).to be false
    end

    it 'quest_four_table does not overlap table premium_2' do
      quest = tables(:quest_four_table)
      premium_2 = tables(:premium_2)

      expect(quest.overlaps?(premium_2)).to be false
      expect(premium_2.overlaps?(quest)).to be false
    end
    it 'quest_four_table does not overlap nil ' do
      quest = tables(:quest_four_table)

      expect(quest.overlaps?(nil)).to be false
    end
  end

  context 'tickets_overlap?' do
    it 'user_event has overlap with table two' do
      registration = user_events(:normal_guy_my_event)
      table = tables(:two)

      expect(table.tickets_overlap?(registration)).to be true
    end

    it 'empty_registration_tables does not overlap' do
      registration = user_events(:empty_registration_tables)
      table = tables(:two)

      expect(table.tickets_overlap?(registration)).to be false
    end

    it 'gamemaster_event does  overlap' do
      registration = user_events(:gamemaster_event)
      table = tables(:two)

      expect(table.tickets_overlap?(registration)).to be true
    end
  end

end
