class NewsItemsStories < ActiveRecord::Migration
    def change
    create_table :newsitems_stories, id: false do |t|
      t.integer :newsitem_id
      t.integer :story_id
    end
  end
end