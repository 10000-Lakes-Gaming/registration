# frozen_string_literal: true

class UpdateTicketSeats < ActiveRecord::Migration[5.0]
  def self.up
    say_with_time 'Clearing out all seats for reset.' do
      RegistrationTable.all.each do |f|
        f.update_attribute :seat, nil
      end
    end
    say_with_time 'Set new seat values on all tables' do
      Table.all.each do |table|
        puts "Updating table #{table.id} with #{table.registration_tables.length} tickets"
        table.registration_tables.each do |ticket|
          next unless ticket.seat.nil?

          seat = RegistrationTable.where(table_id: ticket.table.id).maximum('seat')
          if seat.nil?
            seat = 1
          else
            seat += 1
          end
          ticket.update_attribute :seat, seat
        end
      end
    end
  end
end
