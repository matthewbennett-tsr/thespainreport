class AddIpColumnsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_subscription_ip_country_name, :string
  end
end
