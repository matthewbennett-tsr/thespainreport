class AddSlugToNewsitems < ActiveRecord::Migration
  def change
    add_column :newsitems, :slug, :string
  end
end
