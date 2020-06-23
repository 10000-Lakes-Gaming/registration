desc "This is used to generate various on demand emails."

task :send_donation_drive_message => :environment do
  puts "Sending donation drive message"
  # this is currently hardcoded for SkålCon 2019
  event = Event.find(10)
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

task :send_registration_update_message => :environment do
  puts "Sending Registration Update message"
  # this is currently hardcoded for SkålCon 2019
  event = Event.find(10)
  message = Message.new
  message.subject = "Are you ready for #{event.name}?"
  count = 0
  event.user_events.each do |registration|
    unless registration.user.opt_out?
      ContactMailer.registration_update(message, registration.user.email, event, registration).deliver
      count += 1
    end
  end
  puts "#{count} Registration Update emails were sent."
end

task :send_skalcon_announcement => :environment do
  puts "Sending out registration reminder"

  message = Message.new
  message.subject = "The physical SkålCon 2020 convention is canceled"
  count = 0
  users = User.all
  users.each do |user|
    if user.opt_out?
      puts "User #{user} opted out of emails"
    else
      ContactMailer.skalcon_announcement(message, user).deliver
      count += 1
    end
  end
  puts "#{count} skalcon_announcement emails were sent."
end
