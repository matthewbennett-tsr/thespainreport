class AddUrgencyToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :urgency, :string
  end
end
