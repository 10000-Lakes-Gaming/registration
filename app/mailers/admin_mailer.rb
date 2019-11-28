class AdminMailer < ApplicationMailer

  def cotn_gm_request_email(message)
    hardcoded = ['brown285@umn.edu']
    @previous = message.email_list

    message.email_list = hardcoded

    # send an email to each individual
    message.email_list.each do |email|
      mail(subject: message.subject, to: email) do |format|
        format.html
        format.text
      end
    end
  end
end
