class AddUrlToCampaign < ActiveRecord::Migration
  def change
  	add_column :campaigns, :url, :string
  end
end
