require 'rails_helper'

describe UserEvent, type: :model do
  fixtures :all

  # Set up the fixures uses in the minitest tests
  let(:admin_my_event) { user_events(:admin_my_event) }
  let(:normal_guy_my_event) { user_events(:normal_guy_my_event) }
  let(:admin_other_event) { user_events(:admin_other_event) }
  let(:paid_event) { user_events(:paid_user_event) }
  let(:admin) { users(:admin) }
  let(:normal_guy) { users(:normal_guy) }
  let(:my_event) { events(:my_event) }
  let(:empty_reg_tables) { user_events(:empty_registration_tables) }

  context '#unique_scenarios' do
    it 'admin_my_event has 2 unique scenarios' do
      table1 = tables(:one)
      table2 = tables(:two)
      expect(admin_my_event.unique_scenarios).to contain_exactly(table1.scenario, table2.scenario)
    end

    it 'gamemaster_event has 1 unique scenarios' do
      gamemaster_event = user_events(:gamemaster_event)
      table1 = tables(:one)
      expect(gamemaster_event.unique_scenarios).to contain_exactly(table1.scenario)
    end

    it 'admin_other_event has 0 unique scenarios' do
      gamemaster_event = user_events(:admin_other_event)
      expect(gamemaster_event.unique_scenarios).to be_empty
    end
  end

  ## These were copied in from the old tests
  context 'tests copied from the minitest tests' do
    it "@empty_reg_tables  has no table signups!" do
      expect(empty_reg_tables.no_signups?).to be true
    end

    it "paid_event has  table signups!" do
      expect(paid_event.no_signups?).to be false
    end

    it 'User event has no registrations' do
      expect(empty_reg_tables.registration_tables.empty?).to be true
    end

    it 'User event HAS registations' do
      expect(paid_event.registration_tables.empty?).to be false
    end

    it 'Admin has his events and not others' do
      expect(admin.user_events).to include(admin_my_event, admin_other_event)
      expect(admin.user_events).to_not include(normal_guy_my_event)
    end

    it 'Normal Guy has his event and not others' do
      expect(normal_guy.user_events).to_not include(admin_my_event, admin_other_event)
      expect(normal_guy.user_events).to include(normal_guy_my_event)
    end

    it 'sort normal is before admin (by name)' do
      expect(admin_my_event <=> normal_guy_my_event).to eq 1
    end

    it 'sort normal is before nil' do
      expect(normal_guy <=> nil).to eq -1
    end

    it 'no game master list is safe' do
      expect(normal_guy_my_event.current_gming_count).to eq 0
      expect(normal_guy_my_event.game_masters).to eq []
      expect(normal_guy_my_event.game_masters.nil?).to be false
    end

    it 'not a gm' do
      expect(normal_guy_my_event.gamemaster?).to be false
    end

    it 'Name of registration is that of the event' do
      expect(my_event.name).to eq(normal_guy_my_event.name)
    end

    it 'Total Payment for event with no premium tables equals event cost' do
      pending 'Need to figure out fixtures that make this work'
      expect(my_event.price).to eq paid_event.total_paid
    end

    it 'Total price equals price of event plus tables' do
      expect(paid_event.total_price).to be 40
    end

    it 'Paid event, unpaid table, paid not equal price' do
      reg = user_events(:paid_event_unpaid_table)
      expect(reg.total_paid).to eq reg.total_paid
    end

    it 'Unpaid additional payment returns true' do
      reg = user_events(:paid_user_event_unpaid_additional)
      expect(reg.unpaid_additional_payments?).to be true
    end

    it 'Paid additional payment returns false' do
      reg = user_events(:normal_guy_my_event)
      expect(reg.unpaid_additional_payments?).to be_falsey
    end
  end

  context '#registration_cost' do
    it 'if no donation then event price' do
      expect(admin_my_event.registration_cost).to eq my_event.price
    end

    it 'if (optional) donation set, then that' do
      admin_my_event.donation = 44
      expect(admin_my_event.registration_cost).to eq 44
    end
  end
end
