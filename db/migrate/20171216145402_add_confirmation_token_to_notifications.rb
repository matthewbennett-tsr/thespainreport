class AddConfirmationTokenToNotifications < ActiveRecord::Migration
  def change
   add_column :notifications, :update_token, :string
  end
end
