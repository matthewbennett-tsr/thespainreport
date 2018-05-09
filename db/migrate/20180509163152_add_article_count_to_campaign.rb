class AddArticleCountToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :article_count, :integer
  end
end
