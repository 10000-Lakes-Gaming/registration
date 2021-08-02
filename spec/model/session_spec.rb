# frozen_string_literal: true

require 'rails_helper'

describe Session do
  fixtures :all

  context '#id' do
    it 'morning' do
      morning = sessions(:morning)
      expect(morning.id).to eq 971_652_664
    end

    it 'evening' do
      evening = sessions(:evening)
      expect(evening.id).to eq 1_008_494_737
    end
  end

  context 'tables (splitting)' do
    it 'tables list all tables, not split out' do
      morning = sessions(:morning)
      one = tables(:one)
      two = tables(:two)
      core = tables(:core)
      raffle = tables(:raffle)
      premium = tables(:premium)
      full = tables(:full)
      online = tables(:online)
      premium_online = tables(:premium_online)

      expect(morning.player_tables).to include(one, two, core, raffle, premium, full, online, premium_online)
      expect(morning.player_tables.length).to be 8
    end

    it 'premium_tables list only premium tables' do
      morning = sessions(:morning)
      one = tables(:one)
      raffle = tables(:raffle)
      premium = tables(:premium)
      online = tables(:online)
      premium_online = tables(:premium_online)

      expect(morning.premium_tables).to include(premium, premium_online)
      expect(morning.premium_tables).to_not include(one, online, raffle)
      expect(morning.premium_tables.length).to be 2
    end

    it 'in_person_premium_tables list only in person premium tables' do
      morning = sessions(:morning)
      one = tables(:one)
      raffle = tables(:raffle)
      premium = tables(:premium)
      online = tables(:online)

      expect(morning.in_person_premium_tables).to include(premium)
      expect(morning.in_person_premium_tables).to_not include(one, online, raffle)
      expect(morning.in_person_premium_tables.length).to be 1
    end

    it 'in_person_regular_tables list only in person regular tables' do
      morning = sessions(:morning)
      one = tables(:one)
      two = tables(:two)
      core = tables(:core)
      raffle = tables(:raffle)
      full = tables(:full)
      premium = tables(:premium)
      online = tables(:online)
      premium_online = tables(:premium_online)

      expect(morning.in_person_regular_tables).to_not include(premium, online, premium_online)
      expect(morning.in_person_regular_tables).to include(one, core, two, full, raffle)
      expect(morning.in_person_regular_tables.length).to be 5
    end

    it 'online_regular_tables list only only online_regular_tables tables' do
      morning = sessions(:morning)
      one = tables(:one)
      raffle = tables(:raffle)
      premium = tables(:premium)
      online = tables(:online)

      expect(morning.online_regular_tables).to include(online)
      expect(morning.online_regular_tables).to_not include(one, premium, raffle)
      expect(morning.online_regular_tables.length).to be 1
    end

    it 'Online regular tables does not list headquarters' do
      other_session = sessions(:other_session)
      other_one = tables(:other_one)
      headquarters = tables(:other_hq)

      expect(other_session.online_regular_tables).to include(other_one)
      expect(other_session.online_regular_tables).to_not include(headquarters)
    end

    it 'online_premium_tables list only only online_premium_tables tables' do
      morning = sessions(:morning)
      premium_online = tables(:premium_online)
      other_one = tables(:other_one)

      expect(morning.online_premium_tables).to include(premium_online)
      expect(morning.online_premium_tables).to_not include(other_one)
      expect(morning.online_premium_tables.length).to be 1
    end
  end

  context 'premium_tables?' do
    it 'true if there are any premium tables' do
      morning = sessions(:morning)
      expect(morning.premium_tables?).to be true
    end

    it 'false if there are no premium tables' do
      other_session = sessions(:other_session)
      expect(other_session.premium_tables?).to be false
    end
  end

  context 'online_tables?' do
    it 'true if there are any online tables' do
      morning = sessions(:morning)
      expect(morning.online_tables?).to be true
    end

    it 'false if there are no online tables' do
      quest_four = sessions(:quest_four)
      expect(quest_four.online_tables?).to be false
    end
  end

  # TODO: Add tests for max players validation
end
