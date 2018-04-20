class AddKeyToCampaign < ActiveRecord::Migration
  def change
  	add_column :campaigns, :keyword, :string
  end
end
