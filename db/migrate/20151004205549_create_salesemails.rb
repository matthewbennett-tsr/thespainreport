class CreateSalesemails < ActiveRecord::Migration
  def change
    create_table :salesemails do |t|

      t.timestamps null: false
    end
  end
end
