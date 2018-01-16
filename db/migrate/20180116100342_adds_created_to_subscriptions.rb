class AddsCreatedToSubscriptions < ActiveRecord::Migration
	def change
		add_column :subscriptions, :stripe_subscription_created, :datetime
	end
end
