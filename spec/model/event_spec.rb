require 'rails_helper'

describe Event, type: :model do

  context 'One of in_person or online must be selected' do
    it 'If only in_person selected validation passes' do
      event = Event.new

      expect(event.event_type_selected).to be true
    end

    it 'If only online selected validation passes' do
      event = Event.new
      event.online = true
      event.in_person = false

      expect(event.event_type_selected).to be true
    end

    it 'If both are selected validation passes' do
      event = Event.new
      event.online = true
      event.in_person = true

      expect(event.event_type_selected).to be true
    end

    it 'If neither are selected validation passes' do
      event = Event.new
      event.online = false
      event.in_person = false

      event.save
      expect(event.event_type_selected).to be false
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
end
