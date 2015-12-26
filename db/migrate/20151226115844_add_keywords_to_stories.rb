class AddKeywordsToStories < ActiveRecord::Migration
  def change
    add_column :stories, :keywords, :string
  end
end