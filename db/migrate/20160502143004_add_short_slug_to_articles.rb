class AddShortSlugToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :short_slug, :string
    add_column :articles, :short_headline, :string
    add_column :newsitems, :short_slug, :string
    add_column :newsitems, :short_headline, :string
  end
end
