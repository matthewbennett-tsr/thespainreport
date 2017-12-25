class ThingsToNotificationtype < ActiveRecord::Migration
  def change
    add_column :notificationtypes, :name, :string
  end
end
