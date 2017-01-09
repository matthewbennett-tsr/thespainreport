class AddIdsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :user_id, :integer
    add_column :invoices, :subscription_id, :integer 
  end
end
