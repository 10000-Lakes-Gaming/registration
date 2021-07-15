# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def cotn_gm_request_email(message)
    @message = message
    message.subject = 'Call for Vols for MN-POP at Con of the North 2020' if message.subject.blank?
    mail(subject: message.subject, to: message.email) do |format|
      format.html
      format.text
    end
  end
end
