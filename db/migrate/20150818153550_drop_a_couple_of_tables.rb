class DropACoupleOfTables < ActiveRecord::Migration
  def change
    drop_table :sources
    drop_table :roles
    drop_table :organisations
    drop_table :articles_article_types
  end
end
