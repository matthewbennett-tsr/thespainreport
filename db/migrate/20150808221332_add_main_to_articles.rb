class AddMainToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :main, :string
  end
end
