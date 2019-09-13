desc "This is used to generate various on demand emails."

task :send_donation_drive_message => :environment do
  puts "Sending donation drive message"
  # this is currently hardcoded for SkålCon 2019
  event           = Event.find(10)
  message         = Message.new
  message.subject = "#{event.name} Physical Goods Donation Drive!"
  count           = 0
  event.user_events.each do |registration|
    ContactMailer.donation_drive(message, registration.user.email, event).deliver
    count += 1
  end
  puts "#{count} donation drive emails were sent."
end

task :send_registration_update_message => :environment do
  puts "Sending Registration Update message"
  # this is currently hardcoded for SkålCon 2019
  event           = Event.find(10)
  message         = Message.new
  message.subject = "Are you ready for #{event.name}?"
  count           = 0
  event.user_events.each do |registration|
    ContactMailer.registration_update(message, registration.user.email, event, registration).deliver
    count += 1
  end
  puts "#{count} Registration Update emails were sent."
end
