class AddsFreeToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :is_free, :boolean
  end
end
