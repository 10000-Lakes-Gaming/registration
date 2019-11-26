class AdminMailer < ApplicationMailer

  def cotn_gm_request_email(event, admins, emails)
    @event = event

    mail(subject: "Please volunteer to GM for #{@event.name}", to: admins.pluck(:email), bcc: emails.pluck(:email)) do |format|
      format.html
    end
  end
end
