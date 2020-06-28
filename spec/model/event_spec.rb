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
end
