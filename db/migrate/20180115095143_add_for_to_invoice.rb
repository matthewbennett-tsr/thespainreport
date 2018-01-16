class AddForToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_for, :string
  end
end
