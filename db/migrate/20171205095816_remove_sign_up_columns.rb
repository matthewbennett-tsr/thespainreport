class RemoveSignUpColumns < ActiveRecord::Migration
  def change
    remove_column :users, :allow_access
    remove_column :users, :sign_up_url
  end
end
