class AddOrderToSalesemails < ActiveRecord::Migration
  def change
    add_column :salesemails, :send_order, :string
  end
end
