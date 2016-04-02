class AddStuffToOrganisation < ActiveRecord::Migration
  def change
    add_column :organisations, :twitter, :string
    add_column :organisations, :facebook, :string
    add_column :organisations, :presspage, :string
    add_column :organisations, :pressemail, :string
    add_column :organisations, :pressphone, :string
  end
end
