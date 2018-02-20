class AddDiscountToSubsInvoice < ActiveRecord::Migration
  def change
    add_column :subscriptions, :discount, :integer
    add_column :invoices, :discount, :integer
  end
end
