class CreateNewsitems < ActiveRecord::Migration
  def change
    create_table :newsitems do |t|
      t.text :item
      t.string :source

      t.timestamps null: false
    end
  end
end
