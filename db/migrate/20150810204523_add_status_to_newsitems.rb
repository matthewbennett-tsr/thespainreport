class AddStatusToNewsitems < ActiveRecord::Migration
  def change
    add_column :newsitems, :status, :string
  end
  
  def change
    add_column :newsitems, :caption, :string
  end
  
  def change
    add_column :newsitems, :imagesource, :string
  end
end
