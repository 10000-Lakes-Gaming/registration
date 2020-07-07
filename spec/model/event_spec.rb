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
      event.chat_server_url = '   '

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end

    it 'If an event has a blanl chat_server and a chat_server_url error should exist' do
      event = Event.new
      event.chat_server = '  '
      event.chat_server_url = 'https://my.chat.server/'

      event.save
      expect(event.valid_chat_server).to be false
      expect(event.errors[:chat_server]).to_not be_empty
    end
  end
end
