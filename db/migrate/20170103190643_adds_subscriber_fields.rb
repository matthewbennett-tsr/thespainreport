class AddsSubscriberFields < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_subscription_ip, :string
    add_column :subscriptions, :stripe_subscription_ip_country, :string
    add_column :subscriptions, :stripe_subscription_email, :string
    add_column :subscriptions, :stripe_subscription_plan, :string
    add_column :subscriptions, :stripe_subscription_amount, :integer
    add_column :subscriptions, :stripe_subscription_quantity, :integer
    add_column :subscriptions, :stripe_subscription_tax_percent, :integer
    add_column :subscriptions, :stripe_subscription_tax_amount, :integer
    add_column :subscriptions, :stripe_subscription_trial_end, :datetime
    add_column :subscriptions, :stripe_subscription_current_period_start_date, :datetime
    add_column :subscriptions, :stripe_subscription_current_period_end_date, :datetime
  end
end