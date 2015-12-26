class AddKeywordsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :keywords, :string
    add_column :regions, :keywords, :string
  end
end
