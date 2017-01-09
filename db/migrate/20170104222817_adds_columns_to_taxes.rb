class AddsColumnsToTaxes < ActiveRecord::Migration
  def change
    add_column :taxes, :tax_country_name, :string
    add_column :taxes, :tax_country_code, :string
    add_column :taxes, :tax_country_percent, :decimal
  end
end
