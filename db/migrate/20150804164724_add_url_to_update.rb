class AddUrlToUpdate < ActiveRecord::Migration
  def change
    add_column :newsitems, :url, :string
  end
end
