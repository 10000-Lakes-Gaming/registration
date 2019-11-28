# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  def cotn_gm_request_preview

    @event = Event.first
    setup_admins
    setup_users
    @message = Message.new
    @message.email_list = @users.pluck(:email)
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
