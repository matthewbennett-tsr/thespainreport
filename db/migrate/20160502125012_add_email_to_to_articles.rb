class AddEmailToToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :email_to, :string
  end
end
