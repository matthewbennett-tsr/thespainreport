class AddProvinceToOrgSource < ActiveRecord::Migration
  def change
    add_column :sources, :province_id, :integer
    add_column :organisations, :province_id, :integer
  end
end
