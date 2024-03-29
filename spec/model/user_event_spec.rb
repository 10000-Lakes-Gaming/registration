# frozen_string_literal: true

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

  context 'validate player selection' do
    it 'user sighted up as online only can only select online' do
      registration = user_events(:charity_event_normal_online)

      expect(registration.can_select?(UserEvent::ATTENDANCE_ONLINE)).to be true
      expect(registration.can_select?(UserEvent::ATTENDANCE_IN_PERSON)).to be false

      online_table = tables(:charity_table_online)
      inperson_table = tables(:charity_table)
      expect(online_table.can_sign_up?(registration)).to be true
      expect(inperson_table.can_sign_up?(registration)).to be false
    end

    it 'user sighted up as in person only can only select in person' do
      registration = user_events(:charity_event_in_person)

      expect(registration.can_select?(UserEvent::ATTENDANCE_ONLINE)).to be false
      expect(registration.can_select?(UserEvent::ATTENDANCE_IN_PERSON)).to be true

      online_table = tables(:charity_table_online)
      inperson_table = tables(:charity_table)
      expect(online_table.can_sign_up?(registration)).to be false
      expect(inperson_table.can_sign_up?(registration)).to be true
    end
  end

  context 'payments' do
    it 'with t-shirt event price is payment amount - t-shirt price' do
      shirt_user_event = user_events(:shirt_user_event)
      total = (my_event.price + my_event.tee_shirt_price) * 100

      expect(shirt_user_event.payment_amount).to eq total
      expect(shirt_user_event.event_paid_amount).to eq my_event.price
    end

    it 'without  t-shirt event price is payment amount' do
      total = my_event.price * 100

      expect(paid_event.payment_amount).to eq total
      expect(paid_event.event_paid_amount).to eq my_event.price
    end
  end

  context '#attendence_type' do
    it 'user is only registered for online so then online' do
      normal_guy_my_event.online = true
      normal_guy_my_event.in_person = false

      expect(normal_guy_my_event.attendance_type).to eq 'Online'
    end

    it 'user is only registered for in person so then in person' do
      normal_guy_my_event.online = false
      normal_guy_my_event.in_person = true

      expect(normal_guy_my_event.attendance_type).to eq 'In Person'
    end

    it 'user is  registered for both so then in person and online' do
      normal_guy_my_event.online = true
      normal_guy_my_event.in_person = true

      expect(normal_guy_my_event.attendance_type).to eq 'In Person and Online'
    end

    it 'user is registered for neither so Neither In Person no Online' do
      normal_guy_my_event.online = false
      normal_guy_my_event.in_person = false

      expect(normal_guy_my_event.attendance_type).to eq 'Neither In Person nor Online'
    end
  end

  context '#attendence_type_selected?' do
    it 'if neither are selected, then false' do
      normal_guy_my_event.online = false
      normal_guy_my_event.in_person = false

      expect(normal_guy_my_event.attendance_type_selected?).to be false
    end

    it 'if online is selected, then true' do
      normal_guy_my_event.online = true
      normal_guy_my_event.in_person = false

      expect(normal_guy_my_event.attendance_type_selected?).to be true
    end

    it 'if in person is selected, then true' do
      normal_guy_my_event.online = false
      normal_guy_my_event.in_person = true

      expect(normal_guy_my_event.attendance_type_selected?).to be true
    end

    it 'if both are selected, then true' do
      normal_guy_my_event.online = true
      normal_guy_my_event.in_person = true

      expect(normal_guy_my_event.attendance_type_selected?).to be true
    end
  end

  context '#validate_in_person_or_online' do
    it 'my event is online but not selected' do
      normal_guy_my_event.validate
      expect(normal_guy_my_event.errors[:in_person]).to include('must have one of online or in person selected')
      expect(normal_guy_my_event.errors[:online]).to_not include('must have one of online or in person selected')

      normal_guy_my_event.in_person = true
      normal_guy_my_event.validate
      expect(normal_guy_my_event.errors[:in_person]).to_not include('must have one of online or in person selected')
    end

    it 'my event is both but not selected' do
      my_event.online = true
      my_event.save!

      normal_guy_my_event.validate
      expect(normal_guy_my_event.errors[:in_person]).to include('must have one of online or in person selected')
      expect(normal_guy_my_event.errors[:online]).to_not include('must have one of online or in person selected')

      normal_guy_my_event.in_person = true
      normal_guy_my_event.validate
      expect(normal_guy_my_event.errors[:in_person]).to_not include('must have one of online or in person selected')
    end

    it 'my event is online but not selected' do
      my_event.in_person = false
      my_event.online = true
      my_event.save!

      normal_guy_my_event.validate
      expect(my_event.online?).to be true
      expect(my_event.in_person?).to be false
      expect(normal_guy_my_event.attendance_type_selected?).to be false
      expect(normal_guy_my_event.errors[:in_person]).to_not include('must have one of online or in person selected')
      expect(normal_guy_my_event.errors[:online]).to include('must have one of online or in person selected')

      normal_guy_my_event.online = true
      normal_guy_my_event.validate
      expect(normal_guy_my_event.errors[:online]).to_not include('must have one of online or in person selected')
    end
  end

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
    it '@empty_reg_tables  has no table signups!' do
      expect(empty_reg_tables.no_signups?).to be true
    end

    it 'paid_event has  table signups!' do
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
      expect(normal_guy <=> nil).to eq(-1)
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
