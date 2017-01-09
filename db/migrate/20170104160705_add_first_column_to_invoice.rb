class AddFirstColumnToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :stripe_invoice_id, :string
  end
end