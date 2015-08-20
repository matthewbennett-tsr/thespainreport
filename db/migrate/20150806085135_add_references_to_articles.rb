class AddReferencesToArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :type_id, :integer
  end
end
