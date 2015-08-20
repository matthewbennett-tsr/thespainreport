class ReCreateArticlesArticleTypes < ActiveRecord::Migration
   def change
      drop_table :articles_article_types
    end
  
  def change
    create_table :articles_article_types, id: false do |t|
      t.integer :article_id
      t.integer :article_type_id
    end
  end
end