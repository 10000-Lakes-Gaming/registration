class AddReportingLinkToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :reporting_url, :string
  end
end
