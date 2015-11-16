class AddColumnstoSalesemails < ActiveRecord::Migration
  def change
    add_column :salesemails, :to, :string
    add_column :salesemails, :delay_number, :string
    add_column :salesemails, :delay_period, :string
    add_column :salesemails, :subject, :string
    add_column :salesemails, :message, :text
  end
end
