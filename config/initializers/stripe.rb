# config/initializers/stripe.rb

Rails.configuration.stripe = {
	publishable_key:		ENV['STRIPE_PUBLISHABLE_KEY'],
	secret_key:				ENV['STRIPE_SECRET_KEY'],
	publishable_spain_key:	ENV['STRIPE_SPAIN_PUBLISHABLE_KEY'],
	secret_spain_key:		ENV['STRIPE_SPAIN_SECRET_KEY']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.signing_secret = whsec_1ufIAmEkRokJEbU3LlkJPg4ZvTYT7hKb

StripeEvent.configure do |events|
	events.subscribe 'charge.failed' do |event|
							# Define subscriber behavior based on the event object
		event.class			#=> Stripe::Event
		event.type			#=> "charge.failed"
		event.data.object	#=> #<Stripe::Charge:0x3fcb34c115f8>
		head 200
	end

	events.all do |event|
		# Handle all event types - logging, etc.
	end
end