class DropTableAddColumn < ActiveRecord::Migration
  def change
    drop_table :articles_types
  end
  
  def change
    drop_table :articles_article_types
  end
  
  def change
    add_column :articles, :type_id, :integer
  end
end
