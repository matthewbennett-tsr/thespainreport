class AddForDateToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_for_date, :datetime
  end
end
