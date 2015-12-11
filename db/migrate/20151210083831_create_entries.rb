class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :feed_id
      t.string :atom_id
      t.string :title
      t.string :url
      t.string :content

      t.timestamps null: false
    end
  end
end
