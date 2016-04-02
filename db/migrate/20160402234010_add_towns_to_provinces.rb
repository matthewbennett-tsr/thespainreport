class AddTownsToProvinces < ActiveRecord::Migration
  def change
    add_column :provinces, :towns, :string
  end
end
