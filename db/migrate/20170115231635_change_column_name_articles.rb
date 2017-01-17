class ChangeColumnNameArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :short_headline, :notification_message
    rename_column :articles, :short_slug, :notification_slug
  end
end
