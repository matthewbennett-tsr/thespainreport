class RemoveContentFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :content, :string
  end
end
