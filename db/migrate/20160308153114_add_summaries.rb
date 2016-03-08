class AddSummaries < ActiveRecord::Migration
  def change
    add_column :articles, :summary, :string
    add_column :articles, :summary_slug, :string
    add_column :newsitems, :summary, :string
    add_column :newsitems, :summary_slug, :string
  end
end
