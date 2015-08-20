class AddSignUpUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sign_up_url, :string
  end
end
