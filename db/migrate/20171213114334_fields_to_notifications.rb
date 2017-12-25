class FieldsToNotifications < ActiveRecord::Migration
  def change
    add_reference :notifications, :user
    add_reference :notifications, :story
    add_index :notifications, [:story_id, :user_id]
    add_column :notifications, :urgency, :string
  end
end