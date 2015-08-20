class AddSourceToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :source, :string
  end
end
