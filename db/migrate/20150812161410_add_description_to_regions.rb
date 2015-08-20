class AddDescriptionToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :description, :string
  end
end
