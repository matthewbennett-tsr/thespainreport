class AddsIpToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :stripe_invoice_ip_country_code, :string
    add_column :invoices, :stripe_invoice_ip_country_code_2, :string
  end
end
