class AddAccountSubIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_subscription_id, :integer
  end
end
