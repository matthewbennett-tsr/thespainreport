class AddYouTubeToOrganisation < ActiveRecord::Migration
  def change
    add_column :organisations, :youtube, :string
  end
end
