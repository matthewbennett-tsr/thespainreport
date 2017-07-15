class AddParentToStories < ActiveRecord::Migration
  def change
    add_column :stories, :parent_id, :integer
  end
end
