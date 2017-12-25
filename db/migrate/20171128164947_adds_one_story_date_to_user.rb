class AddsOneStoryDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :one_story_date, :datetime
  end
end
