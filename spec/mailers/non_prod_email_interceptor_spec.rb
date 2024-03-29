# frozen_string_literal: true

require 'rails_helper'

describe NonProdEmailInterceptor do
  let(:good) { 'good@gmail.com' }
  let(:gamer) { 'gamer@paizo.com' }
  let(:allow_list) { "#{good} #{gamer}" }
  let(:registration) { 'registration@10klakesgaming.org' }

  context '#email_ok_to_send' do
    before do
      allow(ENV).to receive(:fetch).with('DEFAULT_SENDER', nil).and_return(registration)
      allow(ENV).to receive(:fetch).with('EMAIL_ALLOW_LIST', nil).and_return(allow_list)
    end

    it 'email not on allow list cannot be sent' do
      bad_email = 'bad@email.com'

      expect(NonProdEmailInterceptor.email_ok_to_send(bad_email)).to be(false)
    end

    it 'and email is on allow list, it is ok to send' do
      expect(NonProdEmailInterceptor.email_ok_to_send(good)).to be(true)
    end

    it 'and registration email is ok to send' do
      expect(NonProdEmailInterceptor.email_ok_to_send(registration)).to be(true)
    end
  end

  context 'ENV' do
    it 'mocked whitelist is returned and includes help and error emails' do
      allow(ENV).to receive(:fetch).with('DEFAULT_SENDER', nil).and_return(registration)
      allow(ENV).to receive(:fetch).with('EMAIL_ALLOW_LIST', nil).and_return(allow_list)

      expect(NonProdEmailInterceptor.allow_list).to eq [good, gamer, registration]
    end

    it 'intercept is true if there is an email allow list' do
      allow(ENV).to receive(:fetch).with('EMAIL_ALLOW_LIST', nil).and_return(allow_list)

      expect(NonProdEmailInterceptor.intercept?).to be true
    end

    it 'without a list intercept if false' do
      allow(ENV).to receive(:fetch).with('EMAIL_ALLOW_LIST', nil).and_return(nil)

      expect(NonProdEmailInterceptor.intercept?).to be false
    end
  end
end
