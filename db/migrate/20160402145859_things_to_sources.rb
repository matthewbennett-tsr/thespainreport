class ThingsToSources < ActiveRecord::Migration
  def change
    add_column :organisations, :generalphone, :string
    add_column :organisations, :generalemail, :string
    add_column :organisations, :website, :string
    add_column :sources, :name, :string
    add_column :sources, :email1, :string
    add_column :sources, :email2, :string
    add_column :sources, :email3, :string
    add_column :sources, :phone1, :string
    add_column :sources, :phone2, :string
    add_column :sources, :phone3, :string
    add_column :quotes, :quote, :string
  end
end
