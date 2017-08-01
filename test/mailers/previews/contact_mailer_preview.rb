# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  def payment_reminder_preview
    setup_user_event
    setup_payment_message
    setup_admins
    ContactMailer.payment_reminder(@message, @admins, @event)
  end


  def session_reminder_preview
    setup_admins
    @message         = Message.new
    @message.email   = "#{ENV['GMAIL_SMTP_USERNAME']}"
    @message.subject = "Reminder Message"
    @message.content = "This is my content"
    @message.name    = "SkålCon"
    ContactMailer.session_reminder(@message, @admins)
  end


  private
  def setup_user_event
    @event              = Event.new
    @event.name         = 'SkålCon 2017'
    @event.prereg_price = 20
    @event.onsite_price = 25
    @event.prereg_ends  = 5.days.from_now
    @event.rsvp_close   = 10.days.from_now
    @user = User.first
  end

  def setup_payment_message
    @message         = Message.new
    @message.subject = "#{@event.name} Reminder"
  end

  def setup_admins
    @admins = User.where(admin: true)
  end
end
