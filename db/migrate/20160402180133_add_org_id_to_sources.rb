class AddOrgIdToSources < ActiveRecord::Migration
  def change
    add_column :sources, :organisation_id, :integer
  end
end
