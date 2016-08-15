class ContactMailer < ApplicationMailer

  def new_message(message)
    @message = message

    mail_subject = @message.subject
  end

end
