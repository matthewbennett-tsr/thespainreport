class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|

      t.timestamps null: false
    end
  end
end
