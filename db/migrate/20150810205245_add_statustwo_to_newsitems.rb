class AddStatustwoToNewsitems < ActiveRecord::Migration
  def change
    add_column :newsitems, :status, :string
  end
end
