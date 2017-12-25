class AddsOrderToNotificationType < ActiveRecord::Migration
  def change
    add_column :notificationtypes, :order, :integer
  end
end
