class AddSpainIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_id_spain, :string
  end
end
