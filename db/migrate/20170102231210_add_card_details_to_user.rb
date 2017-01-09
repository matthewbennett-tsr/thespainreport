class AddCardDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :credit_card_id, :string
    add_column :users, :credit_card_brand, :string
    add_column :users, :credit_card_country, :string
    add_column :users, :credit_card_last4, :string
    add_column :users, :credit_card_expiry_month, :integer
    add_column :users, :credit_card_expiry_year, :integer
  end
end
