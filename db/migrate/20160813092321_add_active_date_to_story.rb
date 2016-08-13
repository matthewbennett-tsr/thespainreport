class AddActiveDateToStory < ActiveRecord::Migration
  def change
    add_column :stories, :last_active, :datetime
  end
end