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
        puts "deleting registration table #{registration_table.id} as it is unpaid after 1 hour."
        registration_table.delete
        count += 1
      end
    end
  end
  puts "Deleted #{count} rows as being out of date."

end
