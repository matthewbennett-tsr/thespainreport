class AddTypeToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :messagetype, :string
  end
end
