class AddNumberToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :number, :string
  end
end
