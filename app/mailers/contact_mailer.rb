class ContactMailer < ApplicationMailer

  def contact_email(message)
    @message = message
    mail(to: @message.email, subject: @message.subject)
  end

end
