# frozen_string_literal: true

class AddDefaultsToOptOut < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :opt_out, from: nil, to: false)

    users = User.where(opt_out: nil)
    users.each do |user|
      user.opt_out = false
      user.save!
    end
  end
end
