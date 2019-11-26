# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  def cotn_gm_request_preview

    @event = Event.first
    AdminMailer.cotn_gm_request_email(@event)
  end
end
