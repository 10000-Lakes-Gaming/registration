# frozen_string_literal: true

require 'rails_helper'

describe User do
  fixtures :all

  context '#gamemaster_for_event(event)' do
    it 'User is game master for event' do
      user = users(:admin)
      event = events(:my_event)

      expect(user.gamemaster_for_event(event)).to be true
    end
  end

  context '#registration_for_event(event)' do
    it 'finds correct user event' do
      user = users(:admin)
      event = events(:my_event)
      registration = user_events(:admin_my_event)

      expect(user.registration_for_event(event)).to eq registration
    end
  end
end
