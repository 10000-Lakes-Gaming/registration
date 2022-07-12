# frozen_string_literal: true

class NonProdEmailInterceptor
  # This will intercept any emails
  def self.delivering_email(message)
    return unless intercept?

    message.to = message.to_addrs.select { |email| email_ok_to_send(email) }
    message.cc = message.cc_addrs.select { |email| email_ok_to_send(email) }
    message.bcc = message.bcc_addrs.select { |email| email_ok_to_send(email) }

    subject = message.subject
    if message.to_addrs.empty?
      message.perform_deliveries = false
      message_text = "Not sending email #{subject} to as no recipients are on the allow list"
    else
      add_prefix(message)
      length = message.to_addrs.length
      message_text = "SENDING email to #{length} recipients that are on the allow list with subject #{subject}"
    end
    Rails.logger.info "action='NonProdEmailInterceptor.delivering_email' message='#{message_text}'"
  end

  def self.intercept?
    ENV.fetch('EMAIL_ALLOW_LIST', nil).present?
  end

  def self.allow_list
    allow_list = ENV.fetch('EMAIL_ALLOW_LIST', nil)
    Rails.logger.info "Email allow list: #{allow_list}"

    return if allow_list.blank?

    # to string is added for nil safety
    allowed = allow_list.split
    allowed + [sender_email]
  end

  # This will check to see if we are in test mode, then
  # If we are in test mode, it will check to see if the email address is on the allow list.
  def self.email_ok_to_send(email_address)
    allow_list.nil? || allow_list.include?(email_address)
  end

  def self.sender_email
    @sender_email ||= ENV.fetch('DEFAULT_SENDER', nil)
  end
end
