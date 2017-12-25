class CreateNotificationtypes < ActiveRecord::Migration
  def change
    create_table :notificationtypes do |t|

      t.timestamps null: false
    end
  end
end
