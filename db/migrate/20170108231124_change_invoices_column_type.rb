class ChangeInvoicesColumnType < ActiveRecord::Migration
  def change
    change_column :subscriptions, :stripe_subscription_tax_percent,  :decimal
    change_column :invoices, :stripe_invoice_tax_percent,  :decimal
  end
end
