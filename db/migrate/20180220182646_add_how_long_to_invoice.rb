class AddHowLongToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :howlong, :integer
  end
end
