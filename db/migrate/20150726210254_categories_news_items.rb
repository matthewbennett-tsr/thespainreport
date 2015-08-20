class CategoriesNewsItems < ActiveRecord::Migration
    def change
    create_table :categories_newsitems, id: false do |t|
      t.integer :category_id
      t.integer :newsitem_id
    end
  end
end
