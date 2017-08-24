desc "This task is called by the Heroku scheduler add-on"

task :clean_unpaid_premium_tables => :environment do
  puts "Cleaning up unpaid premium tables!"

  registration_tables = RegistrationTable.all

  count = 0

  max_time = 1.hour.ago
  puts max_time

  registration_tables.each do |registration_table|
    # Need to find all where payment is not ok
    # and last updated is older than 1 hour.
    # If so, then delete.
    unless registration_table.payment_ok?
      # just easier for me to wrap my head around.
      created = registration_table.created_at
      puts "#{registration_table.id} => #{created}"
      if created <= max_time
        puts "deleting registration_table #{registration_table.id} as it is unpaid after 1 hour."
        registration_table.delete
        count += 1
      end
    end
  end
  puts "Deleted #{count} rows as being out of date."

end


task :send_session_reminder_message => :environment do
  puts "Sending session signup reminder message"
  # TODO - add in a check for no table registrations
  Event.where('prereg_ends > ?', Date.today).each do |event|
    count           = 0
    message         = Message.new
    message.subject = "Please signup for tables at #{event.name}!"
    event.user_events.each do |registration|
      # only send if they don't have a registration table
      if registration.registration_tables.empty?
        ContactMailer.session_reminder(message, registration.user.email, event).deliver
        count += 1
        puts "emailed #{event.name} session signup reminder to #{registration.user.name} (#{registration.user.email})"
      end
    end
    puts "#{count} reminder emails were sent"
  end
end

task :send_unpaid_event_message => :environment do
  puts "Sending unpaid registration emails"
  Event.where('end > ? AND ( prereg_price > 0 or onsite_price > 0)', Date.today).each do |event|
    count           = 0
    message         = Message.new
    message.subject ="Please submit your payment for #{event.name}"
    event.user_events.where(paid: false).each do |registration|
      ContactMailer.payment_reminder(message, registration.user.email, event).deliver
      count += 1
      puts "emailed #{event.name} payment reminder for #{registration.user.name} (#{registration.user.email})"
    end
    puts "#{count} emails were sent"
  end
end