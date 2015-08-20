class AddCaptionToNewsitems < ActiveRecord::Migration
  def change
    add_column :newsitems, :caption, :string
  end
end
