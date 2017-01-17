class AddShortsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :short_lede, :string
  end
end
