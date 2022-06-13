# frozen_string_literal: true

desc 'This is used to generate various on demand emails.'

task send_donation_drive_message: :environment do
  puts 'Sending donation drive message'
  # this is currently hardcoded for SkålCon 2022
  event = Event.find(19)
  message = Message.new
  message.subject = "#{event.name} Physical Goods Donation Drive!"
  count = 0
  event.user_events.each do |registration|
    unless registration.user.opt_out?
      ContactMailer.donation_drive(message, registration.user.email, event).deliver
      count += 1
    end
  end
  puts "#{count} donation drive emails were sent."
end

task send_registration_update_message: :environment do
  puts 'Sending Registration Update message'
  # this is currently hardcoded for SkålCon 2022
  event = Event.find(19)
  message = Message.new
  message.subject = "#{event.name} is coming soon!"
  count = 0
  event.user_events.each do |registration|
    unless registration.user.opt_out?
      ContactMailer.registration_update(message, registration.user.email, event, registration).deliver
      count += 1
    end
  end
  puts "#{count} Registration Update emails were sent."
end

task send_skalcon_announcement: :environment do
  puts 'Sending out registration reminder'

  message = Message.new
  count = 0
  users = User.all
  # Specific to SkålCon 2022
  #
  event_number = ENV['EVENT_ID'] || 19
  event = Event.find(event_number)
  message.subject = "Pathfinders and Starfinders! MN-POP needs your help for #{event.name}!"
  users.each do |user|
    if user.opt_out?
      puts "User #{user} opted out of emails"
    else
      ContactMailer.skalcon_announcement(message, user, event).deliver
      count += 1
    end
  end
  puts "#{count} skalcon_announcement emails were sent."
end

# usage - `bundle exec rake send_all_gm_schedules EVENT_ID=[EVENT_ID]`
# This now works for any event.
task send_all_gm_schedules: :environment do
  event_number = ENV['EVENT_ID']
  abort 'Missing EVENT_ID!' unless event_number.present?

  event = Event.find(event_number)
  puts "Sending out GM schedules for #{event.name}"

  message = Message.new
  message.subject = "Game Master Schedule for #{event.name}"

  event.game_masters.each do |gm|
    user = gm.user_event.user
    email = user.email
    ContactMailer.game_master(message, email, event, gm, false, true).deliver unless user.opt_out?
  end
end

# usage - `bundle exec rake send_all_partipants_schedules EVENT_ID=[EVENT_ID]`
# This now works for any event.
task send_all_partipants_schedules: :environment do
  event_number = ENV['EVENT_ID']
  abort 'Missing EVENT_ID!' unless event_number.present?

  event = Event.find(event_number)
  puts "Sending out GM schedules for #{event.name}"

  message = Message.new
  message.subject = "Schedule for #{event.name}"

  event.user_events.each do |user_event|
    user = user_event.user
    email = user.email
    unless user.opt_out?
      puts "Emailing schedule to #{user.name} and email #{user.email}"
      ContactMailer.participant(message, email, event, user_event).deliver
    end
  end
end
