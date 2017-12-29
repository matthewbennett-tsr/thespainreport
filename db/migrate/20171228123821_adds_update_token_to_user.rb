class AddsUpdateTokenToUser < ActiveRecord::Migration
  def change
   add_column :users, :update_token, :string
  end
end
