class AddBriefingFreqToUser < ActiveRecord::Migration
  def change
    add_column :users, :briefing_frequency, :integer
  end
end
