class DropArticlesArticleTypes < ActiveRecord::Migration
  def change
      drop_table :articles_article_types
  end
  
  def change
      drop_table :article_types
  end
end
