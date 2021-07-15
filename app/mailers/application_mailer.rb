# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  default from: (ENV['GMAIL_SMTP_USERNAME']).to_s, 'Precedence' => 'bulk'
  default to: (ENV['GMAIL_SMTP_USERNAME']).to_s
  # layout 'mailer'
end
