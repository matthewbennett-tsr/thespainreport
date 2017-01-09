class AddCustomerDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :becomes_customer_date, :datetime
  end
end
