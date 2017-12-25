class AddsAccessDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :access_date, :datetime
  end
end
