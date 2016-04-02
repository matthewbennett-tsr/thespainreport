class AddStuffToSources < ActiveRecord::Migration
  def change
    add_column :sources, :twitter, :string
    add_column :sources, :facebook, :string
    add_column :sources, :youtube, :string
    add_column :sources, :job, :string
  end
end
