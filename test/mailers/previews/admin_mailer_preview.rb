# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  def cotn_gm_request_preview

    @event = Event.first
    setup_admins
    setup_users
    AdminMailer.cotn_gm_request_email(@event, @admins, @users)
  end

  def setup_users
    @users = User.all
  end

  def setup_admins
    @admins = User.where(admin: true)
  end
end
