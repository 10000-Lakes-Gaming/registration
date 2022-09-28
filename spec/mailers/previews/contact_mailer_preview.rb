# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  def table_player_preview
    table = Table.find(3)
    event = table.session.event
    user = User.first
    message = Message.new
    message.subject = "Message from the GM of #{event.name} #{table.name}"
    message.content = 'this is a message from your GM'
    message.name = message.subject

    ContactMailer.email_players(message, table, user)
  end

  def payment_reminder_preview
    setup_user_event
    setup_payment_message
    setup_admins
    ContactMailer.payment_reminder(@message, @admins, @event)
  end

  def session_reminder_preview
    @event = Event.first
    @user = User.first
    setup_payment_message
    ContactMailer.session_reminder(@message, @admins, @event)
  end

  def game_master_add_preview
    @event = Event.find(1)
    @user = User.find(1)
    user_event = @user.user_events.first
    game_master = user_event.game_masters.first
    message = Message.new
    message.subject = "Change in GM assignments for #{@event.name}"

    email = @user.email

    ContactMailer.game_master(message, email, @event, game_master, true)
  end

  def game_master_delete_preview
    @event = Event.first
    @user = User.first
    user_event = @user.user_events.first
    game_master = user_event.game_masters.first
    message = Message.new
    message.subject = "Change in GM assignments for #{@event.name}"

    email = @user.email

    ContactMailer.game_master(message, email, @event, game_master, false)
  end

  def game_master_reminder_preview
    @event = Event.find(1)
    @user = User.find(1)
    user_event = @user.user_events.first
    game_master = user_event.game_masters.first
    message = Message.new
    message.subject = "GM assignment Reminder for #{@event.name}"

    email = @user.email

    ContactMailer.game_master(message, email, @event, game_master, false, true)
  end

  def participant_reminder_preview
    @event = Event.find(1)
    @user = User.find(1)
    user_event = @user.user_events.first
    message = Message.new
    message.subject = "Your #{@event.name} schedule and information"

    email = @user.email

    ContactMailer.participant(message, email, @event, user_event)
  end

  def donation_drive_preview
    @event = Event.first
    @user = User.first
    message = Message.new
    message.subject = "#{@event.name} Donation Drive!"

    ContactMailer.donation_drive(message, @user, @event)
  end

  def registration_update_preview
    @event = Event.first
    @user = User.first
    @user_event = @user.user_events.first

    message = Message.new
    message.subject = "Stuff for #{@event.name}"

    ContactMailer.registration_update(message, @user.email, @event, @user_event)
  end

  def skalcon_announcement_preview
    @user = User.first
    event = Event.first

    message = Message.new
    message.subject = "#{event.name} is almost here! Please register and sign up for tables!"

    ContactMailer.skalcon_announcement(message, @user, event)
  end

  private

  def setup_user_event
    @event = Event.new
    @event.name = 'SkålCon 2018'
    @event.prereg_price = 20
    @event.onsite_price = 25
    @event.prereg_ends = 5.days.from_now
    @event.rsvp_close = 10.days.from_now
    @user = User.first
  end

  def setup_payment_message
    @message = Message.new
    @message.subject = "#{@event.name} Reminder"
  end

  def setup_admins
    @admins = User.where(admin: true)
  end
end
