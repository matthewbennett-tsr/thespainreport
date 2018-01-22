class AddAccountRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_role, :string
    add_column :accounts, :name, :string
  end
end
