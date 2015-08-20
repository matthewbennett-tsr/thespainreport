class AddUrgencyToStory < ActiveRecord::Migration
  def change
    add_column :stories, :urgency, :string
  end
end
