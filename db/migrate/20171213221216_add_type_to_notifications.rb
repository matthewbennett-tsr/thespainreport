class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notificationtype_id, :integer
  end
end
