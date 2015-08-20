class AddImageColumnToNewsitems < ActiveRecord::Migration
  def change
    add_column :newsitems, :newsitem_image, :string
  end
end
