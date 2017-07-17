class AddDefaultPrice < ActiveRecord::Migration[5.0]
  def up
    change_column_default :events, :price, 0
    change_column_default :tables, :price, 0

    Event.find_each do |event|
      if event.price.nil?
        event.price = 0
        event.save!
      end
    end

    Table.find_each do |table|
      if table.price.nil?
        table.price = 0
        table.save!
      end
    end
  end
end
