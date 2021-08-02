# frozen_string_literal: true

require 'rails_helper'

describe TablesController, type: :controller do
  include Devise::Test::ControllerHelpers
  fixtures :all

  before :each do
    admin = users(:admin)
    sign_in admin

    @file = fixture_file_upload('files/tables.csv', 'text/csv')
  end

  context '#index' do
    it 'can render' do
      event = events(:my_event)
      session = sessions(:morning)

      get :index, params: { event_id: event.id, session_id: session.id }

      expect(assigns(:tables)).to_not be_nil
    end
  end

  context 'upload CSV' do
    it 'can upload a file to load_from_csv endpoint' do
      session = sessions(:morning)
      table_count = session.tables.count

      post :load_from_csv, params: { session_id: session.id, file: @file }

      expect(table_count).to be 9
      session.reload
      expect(session.tables.count).to eq(table_count + 2)
    end
  end
end
