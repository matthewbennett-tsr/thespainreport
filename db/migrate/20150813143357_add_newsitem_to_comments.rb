class AddNewsitemToComments < ActiveRecord::Migration
  def change
    add_column :comments, :newsitem_id, :integer
  end
end
