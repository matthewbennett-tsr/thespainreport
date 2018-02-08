class AddHowLongToSubscription < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :stripe_subscription_howlong, :integer
  end
end
