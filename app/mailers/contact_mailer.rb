class ContactMailer < ApplicationMailer

  def contact_email(message)
    @message = message
    @from = @message.email
    mail(from: message.email, reply_to: message.email, subject: message.subject)
  end

  def admin_email(message, emails)
    @message = message
    @emails = emails
    # mail(subject: message.subject, bcc: @emails)
    # let's try iteration
    @emails.each do |email|
      mail(subject: message.subject, bcc: @emails)
    end


  end


  def session_reminder(message, emails)
    @message = message
    list = emails.split(",")
    puts "The list => #{list}"
    list.each_slice(2) do |email_list|
      puts "Sending to #{email_list}"
      @emails = email_list.join(",")
      # @email = email
      @email = "silbeg@comcast.net"

      mail(subject: "#{@message.subject} -> #{@emails}" , to: @email)
      sleep 5.seconds
    end
  end

  def payment_reminder(message, emails)
    @message = message
    @emails = emails
    mail(subject: @message.subject, bcc: @emails)
  end

  def registration_reminder(message, emails)
    @message = message
    @emails = emails
    mail(subject: @message.subject, bcc: @emails)
  end

end
