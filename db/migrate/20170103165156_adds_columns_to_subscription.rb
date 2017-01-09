class AddsColumnsToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_customer_id, :string
    add_column :subscriptions, :stripe_subscription_id, :string
    add_column :subscriptions, :stripe_subscription_credit_card_country, :string
  end
end
