class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :headline
      t.string :lede
      t.text :body

      t.timestamps null: false
    end
  end
end
