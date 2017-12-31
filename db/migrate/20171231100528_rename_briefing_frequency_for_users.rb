class RenameBriefingFrequencyForUsers < ActiveRecord::Migration
  def change
    rename_column :users, :briefing_frequency, :briefing_frequency_id
  end
end
