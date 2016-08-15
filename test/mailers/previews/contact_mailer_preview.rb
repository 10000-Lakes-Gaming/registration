# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  def sample_mail_preview
    # Create the message
    message = Message.new
    message.name = "Test Name"
    message.subject = "this is a test"
    message.content = "This is a test message"
    message.email = 'silbeg@gmail.com'
    ContactMailer.contact_email(message)
  end
end
