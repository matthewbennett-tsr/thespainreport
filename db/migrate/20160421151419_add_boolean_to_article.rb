class AddBooleanToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :topstory, :boolean, default: false
  end
end
