class CreateBriefingFrequencies < ActiveRecord::Migration
  def change
    create_table :briefing_frequencies do |t|
      t.string :name
      t.integer :briefing_frequency

      t.timestamps null: false
    end
  end
end
