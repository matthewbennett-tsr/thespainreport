class AddBcdsToUser < ActiveRecord::Migration
  def change
    add_column :users, :becomes_customer_date_spain, :datetime
  end
end
