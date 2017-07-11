class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  default from: "#{ENV['GMAIL_SMTP_USERNAME']}", "Precedence" => "bulk"
  default to: "#{ENV['GMAIL_SMTP_USERNAME']}"
  # layout 'mailer'
end
