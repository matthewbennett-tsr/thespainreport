class AddReadDateToHistory < ActiveRecord::Migration
  def change
    add_column :histories, :read_date, :datetime
  end
end
