class AddsStoryidToUser < ActiveRecord::Migration
  def change
    add_column :users, :one_story_id, :integer
  end
end
