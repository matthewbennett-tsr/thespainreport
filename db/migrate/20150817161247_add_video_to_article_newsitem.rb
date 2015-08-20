class AddVideoToArticleNewsitem < ActiveRecord::Migration
  def change
    add_column :articles, :video, :string
    add_column :newsitems, :video, :string
  end
end
