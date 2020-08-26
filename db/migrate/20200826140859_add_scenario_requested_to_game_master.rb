class AddScenarioRequestedToGameMaster < ActiveRecord::Migration[5.2]
  def change
    add_column :game_masters, :scenario_requested, :date

    # To support this, we need to better define venture officer.
    User.all.each do |user|
      if VO_TITLES.include? user.title
        user.venture_officer = true
      else
        user.venture_officer = false
      end
      user.save!
    end
  end
end
