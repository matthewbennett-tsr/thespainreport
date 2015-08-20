class ArticlesStories < ActiveRecord::Migration
  def change
      drop_table :articles_stories
  end  
  
   def change
    create_table :articles_stories, id: false do |t|
      t.integer :article_id
      t.integer :story_id
    end
  end
end