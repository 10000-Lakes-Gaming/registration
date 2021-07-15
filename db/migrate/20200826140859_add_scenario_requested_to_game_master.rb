# frozen_string_literal: true

class AddScenarioRequestedToGameMaster < ActiveRecord::Migration[5.2]
  def change
    add_column :game_masters, :scenario_requested, :date

    # To support this, we need to better define venture officer.
    User.all.each do |user|
      user.venture_officer = User::VO_TITLES.include? user.title
      user.save!
    end
  end
end
