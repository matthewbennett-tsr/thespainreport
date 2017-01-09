class AddsIntervalToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_subscription_interval, :string
    remove_column :subscriptions, :stripe_subscription_tax_amount
  end
end
