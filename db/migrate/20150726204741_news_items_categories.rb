class NewsItemsCategories < ActiveRecord::Migration
    def change
      drop_table :newsitems_categories
    end
    
    def change
    create_table :categories_newsitems, id: false do |t|
      t.integer :category_id
      t.integer :newsitem_id
    end
  end
end
