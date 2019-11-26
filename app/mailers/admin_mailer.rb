class AdminMailer < ApplicationMailer

  def cotn_gm_request_email(event)
    @event = event

    mail(subject: "Please volunteer to GM for #{@event.name}", to: 'test@email.com', bcc: ENV["GMAIL_SMTP_USERNAME"]) do |format|
      format.html
    end
  end
end
