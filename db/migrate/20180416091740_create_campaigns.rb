class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|

      t.timestamps null: false
    end
    
    add_column :campaigns, :headline, :string
    add_column :campaigns, :lede, :string
    add_column :campaigns, :text, :string
  end
end
