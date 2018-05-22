class AddEmailCountToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :email_count, :integer
  end
end
