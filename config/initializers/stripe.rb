# config/initializers/stripe.rb

Rails.configuration.stripe = {
	publishable_key:		ENV['STRIPE_PUBLISHABLE_KEY'],
	secret_key:				ENV['STRIPE_SECRET_KEY'],
	publishable_spain_key:	ENV['STRIPE_PUBLISHABLE_SPAIN_KEY'],
	secret_spain_key:		ENV['STRIPE_SECRET_SPAIN_KEY']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]