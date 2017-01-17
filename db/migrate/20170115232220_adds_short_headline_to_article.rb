class AddsShortHeadlineToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :short_headline, :string
  end
end
