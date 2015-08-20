class AddStatusToStory < ActiveRecord::Migration
  def change
    add_column :stories, :status, :string
    add_column :stories, :description, :string
  end
end
