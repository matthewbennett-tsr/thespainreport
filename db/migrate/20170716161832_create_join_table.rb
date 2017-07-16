class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :stories, :users do |t|
      # t.index [:story_id, :user_id]
      # t.index [:user_id, :story_id]
    end
  end
end
