require 'rails_helper'

describe Table do
  fixtures :events
  fixtures :sessions
  fixtures :tables
  fixtures :scenarios

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
end
