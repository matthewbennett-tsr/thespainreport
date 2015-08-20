class RenameNewsitemsColumn < ActiveRecord::Migration
  def change
    rename_column :newsitems, :newsitem_image, :main
  end
end
