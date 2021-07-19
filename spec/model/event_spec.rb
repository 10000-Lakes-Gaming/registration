# frozen_string_literal: true

require 'rails_helper'

describe Event, type: :model do # rubocop:disable Metrics/BlockLength
  fixtures :events
  fixtures :users
  fixtures :sessions
  fixtures :scenarios
  fixtures :tables
  fixtures :game_masters

  context '#hybrid' do
    it 'My Event is not hybrid' do
      event = events(:my_event)
      expect(event.hybrid?).to be false
    end

    it 'Other is not hybrid' do
      event = events(:other)
      expect(event.hybrid?).to be false
    end

    it 'charity_event is not hybrid' do
      event = events(:charity_event)
      expect(event.hybrid?).to be true
    end
  end

  context '#tables' do
    it 'my event has 11 tables' do
      event = events(:my_event)
      one = tables(:one)
      two = tables(:two)
      core = tables(:core)
      raffle = tables(:raffle)
      premium = tables(:premium)
      premium2 = tables(:premium_2)
      expect(event.tables.length).to be 11
      expect(event.tables).to include(one, two, core, raffle, premium, premium2)
    end
  end

  context '#sessions' do
    it 'my_event has 6 sessions' do
      event = events(:my_event)
      morning = sessions(:morning)
      evening = sessions(:evening)
      expect(event.sessions.length).to be 6
      expect(event.sessions).to include(morning, evening)
    end
  end

  context '#unique_scenarios' do
    it 'my_event has 3 scenarios' do
      event = events(:my_event)

      expect(event.unique_scenarios.size).to be 3
    end
  end

  context '#game_masters' do
    it 'my_event has a total of 4 non-unique game_masters' do
      event = events(:my_event)
      gm_admin_one = game_masters(:gm_admin_one)
      gm_admin_two = game_masters(:gm_admin_two)
      gm_game_master = game_masters(:gm_game_master)
      gm_game_master2 = game_masters(:gm_game_master2)

      expect(event.game_masters.size).to be 4
      expect(event.game_masters).to contain_exactly(gm_admin_one, gm_admin_two, gm_game_master, gm_game_master2)
    end
  end

  context 'One of in_person or online must be selected' do
    it 'If only in_person selected validation passes' do
      event = Event.new

      expect(event.event_type_selected?).to be true
    end

    it 'If only online selected validation passes' do
      event = Event.new
      event.online = true
      event.in_person = false

      expect(event.event_type_selected?).to be true
    end

    it 'If both are selected validation passes' do
      event = Event.new
      event.online = true
      event.in_person = true

      expect(event.event_type_selected?).to be true
    end

    it 'If neither are selected validation passes' do
      event = Event.new
      event.online = false
      event.in_person = false

      event.save
      expect(event.event_type_selected?).to be false
      expect(event.errors[:online]).to_not be_empty
    end
  end

  context 'Event has a chat_server' do
    it 'Event has no chat_server' do
      event = Event.new
      event.chat_server = nil
      event.chat_server_url = nil

      event.save
      expect(event.valid_chat_server).to be true
      expect(event.errors[:chat_server]).to be_empty
    end
    it 'Event has a chat_server and a chat_server_url errors should be empty' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = 'https://www.google.com'

      event.save
      expect(event.valid_chat_server).to be true
      expect(event.errors[:chat_server]).to be_empty
    end

    it 'If event has a chat_server_url but no chat_server error should exist' do
      event = Event.new
      event.chat_server = nil
      event.chat_server_url = 'https://www.google.com'

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has a chat_server and no chat_server_url error should exist' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = nil

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has a chat_server and a blank chat_server_url error should exist' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = " \t\r\n"

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end
    it 'If an event has a chat_server and an empty chat_server_url error should exist' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = ''

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has a blank chat_server and a chat_server_url error should exist' do
      event = Event.new
      # Note that if we do these special characters, we must use double quptes, because Ruby
      event.chat_server = " \t\n\r"
      event.chat_server_url = 'https://my.chat.server/'

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has an empty chat_server and a chat_server_url error should exist' do
      event = Event.new
      event.chat_server = ''
      event.chat_server_url = 'https://my.chat.server/'

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end
  end

  context '#chat_server?' do
    it 'return true if both chat server and URL are present' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = 'https://www.google.com'

      expect(event.chat_server?).to be true
    end

    it 'return false if chat server present and URL is blank' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = ' '

      expect(event.chat_server?).to be false
    end

    it 'return false if chat server blank and URL is present' do
      event = Event.new
      event.chat_server = ' '
      event.chat_server_url = 'https://www.google.com'

      expect(event.chat_server?).to be false
    end

    it 'return false if chat server and URL are blank' do
      event = Event.new
      event.chat_server = ' '
      event.chat_server_url = nil

      expect(event.chat_server?).to be false
    end
  end

  context '#optional_fee' do
    it 'optional fee should be false if not a charity event' do
      event = Event.new
      event.charity = false
      event.prereg_price = 20
      event.onsite_price = 25

      expect(event.optional_fee).to be_falsey
    end

    it 'optional fee set to true for not charity should throw error' do
      event = Event.new
      event.charity = false
      event.prereg_price = 20
      event.onsite_price = 25
      event.optional_fee = true

      event.save
      expect(event.errors[:optional_fee]).to_not be_empty
    end

    it 'charity_optional_fee_ok if charity' do
      event = Event.new
      event.charity = true

      event.save
      expect(event.charity_optional_fee_ok).to be true
      expect(event.errors[:optional_fee]).to be_empty
    end

    it 'charity_optional_fee_ok if charity has optional fee' do
      event = Event.new
      event.charity = true
      event.optional_fee = true

      event.save
      expect(event.charity_optional_fee_ok).to be true
      expect(event.errors[:optional_fee]).to be_empty
    end

    it 'charity_optional_fee_ok if not charity has optioanal fee' do
      event = Event.new
      event.charity = false
      event.optional_fee = true

      event.save
      expect(event.charity_optional_fee_ok).to be false
      expect(event.errors[:optional_fee]).to_not be_empty
    end

    it 'charity_optional_fee_ok if not charity no optional fee' do
      event = Event.new
      event.charity = false
      event.optional_fee = false

      event.save
      expect(event.charity_optional_fee_ok).to be true
      expect(event.errors[:optional_fee]).to be_empty
    end
  end

  context 'Event has a chat_server' do
    it 'Event has no chat_server' do
      event = Event.new
      event.chat_server = nil
      event.chat_server_url = nil

      event.save
      expect(event.valid_chat_server).to be true
      expect(event.errors[:chat_server]).to be_empty
    end
    it 'Event has a chat_server and a chat_server_url errors should be empty' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = 'https://www.google.com'

      event.save
      expect(event.valid_chat_server).to be true
      expect(event.errors[:chat_server]).to be_empty
    end

    it 'If event has a chat_server_url but no chat_server error should exist' do
      event = Event.new
      event.chat_server = nil
      event.chat_server_url = 'https://www.google.com'

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has a chat_server and no chat_server_url error should exist' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = nil

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has a chat_server and a blank chat_server_url error should exist' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = " \t\r\n"

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end
    it 'If an event has a chat_server and an empty chat_server_url error should exist' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = ''

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has a blank chat_server and a chat_server_url error should exist' do
      event = Event.new
      # Note that if we do these special characters, we must use double quptes, because Ruby
      event.chat_server = " \t\n\r"
      event.chat_server_url = 'https://my.chat.server/'

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has an empty chat_server and a chat_server_url error should exist' do
      event = Event.new
      event.chat_server = ''
      event.chat_server_url = 'https://my.chat.server/'

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end
  end

  context '#chat_server?' do
    it 'return true if both chat server and URL are present' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = 'https://www.google.com'

      expect(event.chat_server?).to be true
    end

    it 'return false if chat server present and URL is blank' do
      event = Event.new
      event.chat_server = 'Discord'
      event.chat_server_url = ' '

      expect(event.chat_server?).to be false
    end

    it 'return false if chat server blank and URL is present' do
      event = Event.new
      event.chat_server = ' '
      event.chat_server_url = 'https://www.google.com'

      expect(event.chat_server?).to be false
    end

    it 'return false if chat server and URL are blank' do
      event = Event.new
      event.chat_server = ' '
      event.chat_server_url = nil

      expect(event.chat_server?).to be false
    end
  end

  context 'charity event' do
    it 'It is a charity event with an optional fee' do
      event = events(:charity_event)
      expect(event.charity?).to be true
      expect(event.optional_fee?).to be true
    end

    it 'Calls after add' do
      event = events(:charity_event)
      user = users(:dude1)

      user_event = UserEvent.new
      user_event.user = user
      user_event.event = event
      event.user_events << user_event

      expect(user_event.donation).to eq event.price
    end

    it 'Doesn\'t overwrite donation value if already set' do
      event = events(:charity_event)
      user = users(:dude1)

      user_event = UserEvent.new
      user_event.donation = 50
      user_event.user = user
      user_event.event = event
      event.user_events << user_event

      expect(user_event.donation).to eq 50
    end
  end
end
