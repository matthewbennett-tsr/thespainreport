class AddIndexToEntries < ActiveRecord::Migration
  def change
    add_index :entries, :title
  end
end
