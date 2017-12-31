class AddsCategoryToStory < ActiveRecord::Migration
  def change
    add_column :stories, :category_id, :integer
    remove_column :stories, :parent_id, :integer
  end
end
