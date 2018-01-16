class AddsFieldsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :stripe_invoice_number, :string
    add_column :invoices, :stripe_invoice_currency, :string
    add_column :invoices, :stripe_invoice_interval, :string
  end
end
