class RemovesReadDateFromHistory < ActiveRecord::Migration
  def change
    remove_column :histories, :read_date, :datetime
  end
end
