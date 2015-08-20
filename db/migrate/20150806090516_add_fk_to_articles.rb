class AddFkToArticles < ActiveRecord::Migration
  def change
    add_foreign_key :articles, :types
  end
end
