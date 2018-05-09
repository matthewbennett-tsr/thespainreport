class AddCampaignToArticle < ActiveRecord::Migration
  def change
  	add_column :articles, :campaign_id, :integer
  end
end
