class AddExternalRegistrationUrlToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :external_url, :string
  end
end
