class AdminMailer < ApplicationMailer

  def cotn_gm_request_email(message)

    mail(subject: message.subject, to:  ENV["GMAIL_SMTP_USERNAME"], bcc: message.email_list) do |format|
      format.html
      # format.text
    end
  end
end
