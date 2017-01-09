class AddsColumnsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :stripe_invoice_date, :datetime
    add_column :invoices, :stripe_invoice_item, :string
    add_column :invoices, :stripe_invoice_quantity, :integer
    add_column :invoices, :stripe_invoice_price, :integer
    add_column :invoices, :stripe_invoice_subtotal, :integer
    add_column :invoices, :stripe_invoice_tax_percent, :integer
    add_column :invoices, :stripe_invoice_tax_amount, :integer
    add_column :invoices, :stripe_invoice_total, :integer
  end
end
