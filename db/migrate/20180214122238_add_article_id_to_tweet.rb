class AddArticleIdToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :article_id, :integer
  end
end
