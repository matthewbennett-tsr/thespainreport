class AddEmailPrefToUsers < ActiveRecord::Migration
  def change
    add_column :users, :emailpref, :string
  end
end
