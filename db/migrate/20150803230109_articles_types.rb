class ArticlesTypes < ActiveRecord::Migration
   def change
      drop_table :articles_types
  end  
  
   def change
    create_table :articles_types, id: false do |t|
      t.integer :article_id
      t.integer :type_id
    end
  end
end