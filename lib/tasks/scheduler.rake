desc "This task is called by the Heroku scheduler add-on"

task :clean_unpaid_premium_tables => :environment do
  puts "Cleaning up unpaid premium tables!"

  tables = RegistrationTable.all

  count = 0
  tables.each do |table|
    # Need to find all where payment is not ok
    # and last updated is older than 1 hour.
    # If so, then delete.
    unless table.payment_ok?
      updated_at = table.table.updated_at
      puts updated_at
      if updated_at < 1.hour.ago
        puts "deleting registration table #{table.id} as it is unpaid after 1 hour."
        table.delete
        count.increment
      end
    end
  end
  puts "Deleted #{count} rows as being out of date."

end
