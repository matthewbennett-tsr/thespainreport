class AddAccessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :allow_access, :boolean, default: false
  end
end
