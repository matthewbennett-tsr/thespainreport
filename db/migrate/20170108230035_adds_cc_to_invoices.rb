class AddsCcToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :stripe_invoice_credit_card_country, :string
  end
end
