class NewsItemsRegions < ActiveRecord::Migration
  def change
    create_table :newsitems_regions, id: false do |t|
      t.integer :newsitem_id
      t.integer :region_id
    end
  end
end
