# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def cotn_gm_request_preview
    @event = Event.first
    setup_admins
    setup_users
    @message = Message.new
    @message.subject = 'Call for Vols for MN-POP at Con of the North 2020'
    user = @users.first
    @message.user = user
    @message.email = user.email
    AdminMailer.cotn_gm_request_email(@message)
  end

  private

  def setup_users
    @users = User.all
  end

  def setup_admins
    @admins = User.where(admin: true)
  end
end
