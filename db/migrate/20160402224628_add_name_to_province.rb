class AddNameToProvince < ActiveRecord::Migration
  def change
    add_column :provinces, :name, :string
  end
end
