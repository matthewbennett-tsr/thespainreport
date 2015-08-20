class AddTypeToArticle < ActiveRecord::Migration
  def change
  	add_column :articles, :type_id, :integer
  end
end
