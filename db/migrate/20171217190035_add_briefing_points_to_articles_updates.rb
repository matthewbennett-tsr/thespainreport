class AddBriefingPointsToArticlesUpdates < ActiveRecord::Migration
  def change
    add_column :articles, :briefing_point, :string
    add_column :newsitems, :briefing_point, :string
  end
end
