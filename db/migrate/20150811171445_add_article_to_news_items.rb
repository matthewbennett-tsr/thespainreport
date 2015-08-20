class AddArticleToNewsItems < ActiveRecord::Migration
  def change
    add_column :newsitems, :article_id, :integer
  end
end
