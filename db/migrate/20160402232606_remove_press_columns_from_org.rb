class RemovePressColumnsFromOrg < ActiveRecord::Migration
  def change
    remove_column :organisations, :presspage, :string
    remove_column :organisations, :pressemail, :string
    remove_column :organisations, :pressphone, :string
  end
end
