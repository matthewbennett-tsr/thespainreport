class AddTypeToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_subscription_type, :string
  end
end
