class AddFieldsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_currency, :string
    add_column :subscriptions, :stripe_status, :string
  end
end
