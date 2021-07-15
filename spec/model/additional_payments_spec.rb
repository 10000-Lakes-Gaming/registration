# frozen_string_literal: true

require 'rails_helper'

describe 'AdditionalPayments' do
  fixtures :additional_payments

  context '#unpaid?' do
    it 'Unpaid payment is unpaid' do
      payment = additional_payments(:unpaid_additional)
      expect(payment.unpaid?).to be true
    end

    it 'Paid payment is not unpaod' do
      payment = additional_payments(:paid_payment)
      expect(payment.unpaid?).to be false
    end
  end

  context '#donation_amount'
end
