class AddEmailToToNewsitem < ActiveRecord::Migration
  def change
    add_column :newsitems, :email_to, :string
  end
end
