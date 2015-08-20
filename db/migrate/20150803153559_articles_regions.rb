class ArticlesRegions < ActiveRecord::Migration
   def change
      drop_table :articles_regions
    end
   
   def change
    create_table :articles_regions, id: false do |t|
      t.integer :article_id
      t.integer :region_id
    end
  end
end