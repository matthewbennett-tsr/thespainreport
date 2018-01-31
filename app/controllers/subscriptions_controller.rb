### Adds country selector + subscriptions/spain method
### Removes redirects from error messages
### Adds sign-up fields for new_spain_report_member
### Adds return + flash message after new_spain_report_member sign up


class SubscriptionsController < ApplicationController
	before_action :set_subscription, only: [:show, :edit, :update, :destroy]
	skip_before_action :verify_authenticity_token, only: :stripe_hooks
	protect_from_forgery except: :stripe_hooks

	# All of the which country logic
	def country
		if params[:ip_country_code] == "ES"
			{:api_key => Rails.configuration.stripe[:secret_spain_key]}
		else
			{:api_key => Rails.configuration.stripe[:secret_key]}
		end
	end
	
	def currency
		if params[:ip_country_code] == "ES"
			'eur'
		else
			'gbp'
		end
	end
	
	def country_choice
		if params[:ip_country_code] == "ES"
			@apikey = {:api_key => Rails.configuration.stripe[:secret_spain_key]}
			@currency = 'eur'
			@prefix = 'ES-'
			@howmanyinvoices = Invoice.spain.where('extract(year from created_at) = ?', Time.current.year).count
			
			if current_user.stripe_customer_id_spain?
				@stripe_customer = current_user.stripe_customer_id_spain
			else
				customer = Stripe::Customer.create
				
				@stripe_customer = customer.id
			end
		else
			@apikey = {:api_key => Rails.configuration.stripe[:secret_key]}
			@currency = 'gbp'
			@prefix = ''
			@howmanyinvoices = Invoice.notspain.where('extract(year from created_at) = ?', Time.current.year).count
			
			if current_user.stripe_customer_id?
				@stripe_customer = current_user.stripe_customer_id
			else
				customer = Stripe::Customer.create
				
				@stripe_customer = customer.id
			end
		end
		
		@invoice_number = @prefix + Time.current.year.to_s + (@howmanyinvoices + 1).to_s.rjust(8, '0')
	end
	
	def invoice_number
		if params[:ip_country_code] == 'ES'
			@prefix = 'ES-'
			@howmanyinvoices = Invoice.spain.where('extract(year from created_at) = ?', Time.current.year).count
		else
			@prefix = ''
			@howmanyinvoices = Invoice.notspain.where('extract(year from created_at) = ?', Time.current.year).count
		end
		
		invoice_number = @prefix + Time.current.year.to_s + (@howmanyinvoices + 1).to_s.rjust(8, '0')
	end
	
	def subscription_country_test
		@user = User.find(params[:user_id])
		if @user.subscriptions.any?
			tsr_subscription = @user.subscriptions.last
			if tsr_subscription.stripe_subscription_ip_country == "ES"
				{:api_key => Rails.configuration.stripe[:secret_spain_key]}
			else
				{:api_key => Rails.configuration.stripe[:secret_key]}
			end
		else
			{:api_key => Rails.configuration.stripe[:secret_key]}
		end
	end
	
	def subscription_country
		@user = User.find(params[:user_id])
		if @user.subscriptions.any?
			tsr_subscription = @user.subscriptions.last
			if tsr_subscription.stripe_subscription_ip_country == "ES" && @user.becomes_customer_date >= '2018-01-01'
				{:api_key => Rails.configuration.stripe[:secret_spain_key]}
			elsif tsr_subscription.stripe_subscription_ip_country == "ES" && @user.becomes_customer_date < '2018-01-01'
				{:api_key => Rails.configuration.stripe[:secret_key]}
			else
				{:api_key => Rails.configuration.stripe[:secret_key]}
			end
		else
			{:api_key => Rails.configuration.stripe[:secret_key]}
		end
	end
	
	def new_prepayment
		token = params[:stripeToken]
		email_address = params[:email]
		tax_percent = params[:ts]
		how_many = params[:quantity]
		amount = params[:amount]
		ip_address = params[:ip_address]
		ip_country_code = params[:ip_country_code]
		ip_country_name = params[:ip_country_name]
		
		# Do we need to create a new Stripe customer?
		if User.exists?(email: params[:email]) && current_user.nil?
			redirect_to :back
			flash[:success] = "Please log in to continue."
		elsif User.exists?(email: params[:email]) && current_user.email != params[:email]
			redirect_to :back
			flash[:success] = "Please use your own email."
		elsif User.exists?(email: params[:email]) && current_user.email == params[:email] && current_user.stripe_customer_id.blank?
			@customer = Stripe::Customer.create({
			:source => token,
			:description => email_address
			}, country)
			
			charge = Stripe::Charge.create({
			:customer => @customer.id,
			:description => 'One-time pre-payment',
			:amount => amount,
			:currency => currency
			}, country)
			
			@one_time_date = Time.current + params[:forward].to_i.months
			set_one_time_details
			thespainreport_user_roles
			
			redirect_to :back
			flash[:success] = "Pre-payment successful."
		elsif User.exists?(email: params[:email]) && current_user.email == params[:email] && !current_user.stripe_customer_id.nil?
			@customer = Stripe::Customer.retrieve(current_user.stripe_customer_id, country)
			
			charge = Stripe::Charge.create({
			:customer => @customer.id,
			:description => 'One-time pre-payment',
			:amount => amount,
			:currency => currency
			}, country)
			
			@one_time_date = Time.current + params[:forward].to_i.months
			set_one_time_details
			thespainreport_user_roles
			
			redirect_to :back
			flash[:success] = "Pre-payment successful."
		else
			customer = Stripe::Customer.create({
			:source => token,
			:description => email_address
			}, country)
			
			customer_id = customer.id
			
			charge = Stripe::Charge.create({
			:customer => customer_id,
			:description => 'One-time pre-payment',
			:amount => amount,
			:currency => currency
			}, country)
			
			redirect_to :back
			flash[:success] = "Brand new customer pre-payment successful."
		end	
	end
	
	def new_credit_card
		user = User.find_by_email(params[:email])
		
		if xxxx
			user.update(
				stripe_customer_id_spain: @customer.id,
				becomes_customer_date_spain: Time.at(@customer.created).to_datetime,
				credit_card_id_spain: @customer.sources.data[0].id,
				credit_card_brand_spain: @customer.sources.data[0].brand,
				credit_card_country_spain: @customer.sources.data[0].country,
				credit_card_last4_spain: @customer.sources.data[0].last4,
				credit_card_expiry_month_spain: @customer.sources.data[0].exp_month,
				credit_card_expiry_year_spain: @customer.sources.data[0].exp_year
				)
		else
			user.update(
				stripe_customer_id: @customer.id,
				becomes_customer_date: Time.at(@customer.created).to_datetime,
				credit_card_id: @customer.sources.data[0].id,
				credit_card_brand: @customer.sources.data[0].brand,
				credit_card_country: @customer.sources.data[0].country,
				credit_card_last4: @customer.sources.data[0].last4,
				credit_card_expiry_month: @customer.sources.data[0].exp_month,
				credit_card_expiry_year: @customer.sources.data[0].exp_year
				)
		end
	end
	
	def set_one_time_details
		account = Account.create(
			name: params[:email]
		)
		
		user = User.find_by_email(params[:email])
		user.update(
			
			access_date: @one_time_date,
			account_id: account.id,
			account_role: 'account_boss'
		)
		
		new_credit_card
		
		# A one-time subscription
		subscription = Subscription.new
		subscription.user_id = user.id
		subscription.stripe_customer_id = @customer.id
		subscription.stripe_subscription_id = 'One-time pre-payment'
		subscription.stripe_subscription_email = user.email
		subscription.stripe_subscription_plan = params[:plan]
		subscription.stripe_subscription_amount = params[:amount]
		subscription.stripe_subscription_interval = 'months'
		subscription.stripe_subscription_quantity = params[:quantity]
		subscription.stripe_subscription_tax_percent = params[:ts]
		subscription.stripe_subscription_ip = params[:ip_address]
		subscription.stripe_subscription_ip_country = params[:ip_country_code]
		subscription.stripe_subscription_ip_country_name = params[:ip_country_name]
		subscription.stripe_subscription_credit_card_country = @customer.sources.data[0].country
		subscription.stripe_subscription_current_period_start_date = Time.current.to_datetime
		subscription.stripe_subscription_created = Time.current.to_datetime
		subscription.stripe_subscription_current_period_end_date = @one_time_date
		subscription.stripe_currency = currency
		subscription.stripe_status = 'active'
		subscription.save!
		
		# A one-time invoice
		invoice_number
		
		i = Invoice.new
		i.number = invoice_number
		i.user_id = user.id
		i.subscription_id = subscription.id
		i.stripe_invoice_id = 'One-time invoice'
		i.stripe_invoice_number = 'One-time invoice'
		i.stripe_invoice_date = Time.current.to_datetime
		i.stripe_invoice_item = 'One-time pre-payment'
		i.stripe_invoice_quantity = params[:quantity]
		i.stripe_invoice_price = params[:base_price]
		i.stripe_invoice_subtotal = params[:subtotal]
		i.stripe_invoice_credit_card_country = @customer.sources.data[0].country
		i.stripe_invoice_tax_percent = params[:ts]
		i.stripe_invoice_tax_amount = params[:tax_amount]
		i.stripe_invoice_currency = currency
		i.stripe_invoice_interval = 'months'
		i.stripe_invoice_total = params[:amount]
		i.stripe_invoice_ip_country_code = params[:ip_country_code]
		i.paid = true
		i.status = 'unverified'
		i.save!
		
	end
	
	def new_subscription
		# Get the credit card details from the form and generate stripeToken
		token = params[:stripeToken]
		email_address = params[:email]
		tax_percent = params[:ts]
		how_many = params[:quantity]
		ip_address = params[:ip_address]
		ip_country_code = params[:ip_country_code]
		ip_country_name = params[:ip_country_name]

		if User.exists?(email: params[:email]) && current_user.nil?
			redirect_to :back
			flash[:success] = "Please use another e-mail or log in to continue."
		elsif User.exists?(email: params[:email]) && current_user.role == 'editor'
			redirect_to :back
			flash[:success] = "That user already exists"
		elsif User.exists?(email: params[:email]) && current_user.email != params[:email]
			redirect_to :back
			flash[:success] = "Please enter your own e-mail."
		elsif User.exists?(email: params[:email]) && current_user.email == params[:email] && ['reader', 'guest'].include?(current_user.role)
			redirect_to :back
			flash[:success] = "Please subscribe now."
		elsif User.exists?(email: params[:email]) && current_user.email == params[:email] && ['subscriber', 'subscriber_one_story', 'subscriber_all_stories'].include?(current_user.role) && current_user.access_date < Time.current
			redirect_to :back
			flash[:success] = "Please re-subscribe now."
		elsif User.exists?(email: params[:email]) && current_user.email == params[:email] && ['subscriber_one_story'].include?(current_user.role)
			
			
			redirect_to :back
			flash[:success] = "Upgraded."
		elsif User.exists?(email: params[:email]) && current_user.email == params[:email] && ['subscriber_all_stories'].include?(current_user.role)
			redirect_to :back
			flash[:success] = "Downgrade now."
		
		else

		begin
			# Create a new Stripe customer and add them to a subscription plan
			customer = Stripe::Customer.create({
				:source => token,
				:description => email_address,
				:plan => params[:plan],
				:tax_percent => tax_percent,
				:quantity => how_many}, country)

			# If brand new user, basic account set up
			thespainreport_new_user_create
			thespainreport_user_roles
			set_briefings_and_stories

			# Set up user subscription details
			user = User.find_by_email(params[:email])
			user.update(
				stripe_customer_id: customer.id,
				becomes_customer_date: Time.at(customer.created).to_datetime,
				credit_card_id: customer.sources.data[0].id,
				credit_card_brand: customer.sources.data[0].brand,
				credit_card_country: customer.sources.data[0].country,
				credit_card_last4: customer.sources.data[0].last4,
				credit_card_expiry_month: customer.sources.data[0].exp_month,
				credit_card_expiry_year: customer.sources.data[0].exp_year,
				access_date: Time.at(customer.subscriptions.data[0].current_period_end).to_datetime
			)

			# Create the first subscription record on TSR
			subscription = Subscription.new
			subscription.user_id = user.id
			subscription.stripe_customer_id = customer.id
			subscription.stripe_subscription_id = customer.subscriptions.data[0].id
			subscription.stripe_subscription_email = email_address
			subscription.stripe_subscription_plan = customer.subscriptions.data[0].plan.name
			subscription.stripe_subscription_amount = customer.subscriptions.data[0].plan.amount
			subscription.stripe_subscription_interval = customer.subscriptions.data[0].plan.interval
			subscription.stripe_subscription_quantity = customer.subscriptions.data[0].quantity
			subscription.stripe_subscription_tax_percent = customer.subscriptions.data[0].tax_percent
			subscription.stripe_subscription_ip = ip_address
			subscription.stripe_subscription_ip_country = ip_country_code
			subscription.stripe_subscription_ip_country_name = ip_country_name
			subscription.stripe_subscription_credit_card_country = customer.sources.data[0].country
			subscription.stripe_subscription_current_period_start_date = Time.at(customer.subscriptions.data[0].current_period_start).to_datetime
			subscription.stripe_subscription_current_period_end_date = Time.at(customer.subscriptions.data[0].current_period_end).to_datetime
			subscription.is_active = true
			subscription.save!

			# Create the first invoice for that subscription record on TSR
			stripeinvs = Stripe::Invoice.all({:customer => customer.id, :subscription => customer.subscriptions.data[0].id }, country)
			stripeinvs.each do |stripeinv|
				invoice = Invoice.new
				invoice.stripe_invoice_id = stripeinv.id
				invoice.user_id = user.id
				invoice.subscription_id = subscription.id
				invoice.stripe_invoice_date = Time.at(stripeinv.date).to_datetime
				invoice.stripe_invoice_item = stripeinv.lines.data[0].plan.name
				invoice.stripe_invoice_quantity = stripeinv.lines.data[0].quantity
				invoice.stripe_invoice_price = stripeinv.lines.data[0].plan.amount
				invoice.stripe_invoice_subtotal = stripeinv.subtotal
				invoice.stripe_invoice_credit_card_country = customer.sources.data[0].country
				invoice.stripe_invoice_ip_country_code = ip_country_code
				invoice.stripe_invoice_ip_country_code_2 = ''
				invoice.stripe_invoice_tax_percent = stripeinv.tax_percent
				invoice.stripe_invoice_tax_amount = stripeinv.tax
				invoice.stripe_invoice_total = stripeinv.total
				invoice.paid = stripeinv.paid
				invoice.status = 'unverified'
				invoice.save!
			end
			
			# Send a thank-you e-mail
			UserMailer.delay.new_subscriber_thank_you(user)
			
			# All done, finish up, flash thank-you message on screen
			redirect_to :back
			flash[:success] = "Thanks for subscribing to The Spain Report! Check your e-mail."
		rescue Stripe::CardError => e
			# Since it's a decline, Stripe::CardError will be caught
			body = e.json_body
			err	 = body[:error]
			
			puts "Status is: #{e.http_status}"
			puts "Type is: #{err[:type]}"
			puts "Code is: #{err[:code]}"
			# param is '' in this case
			puts "Param is: #{err[:param]}"
			puts "Message is: #{err[:message]}"
			flash[:error] = "#{err[:message]}"
			redirect_to :back
		rescue Stripe::InvalidRequestError => e
			flash[:error] = "Invalid request to payment processor. Please try again."
			redirect_to :back
		rescue Stripe::AuthenticationError => e
			flash[:error] = "Could not connect to payment processor. Please try again."
			redirect_to :back
		rescue Stripe::APIConnectionError => e
			flash[:error] = "Could not connect to payment processor. Please try again."
			redirect_to :back
		rescue Stripe::StripeError => e
			flash[:error] = "General payment processor problem. Please try again."
			redirect_to :back
		rescue => e
			flash[:error] = "Unspecified problem. Please contact subscriptions@thespainreport.com."
			redirect_to :back
		end
	end
	end


	def stripe_hooks
		event = JSON.parse(request.body.read)
		puts 'Event type: ' + event['type']
		puts 'Event id: ' + event['id']
		puts 'Event date: ' + Time.at(event['created']).to_datetime.to_s
		puts 'Customer: ' + event['data']['object']['customer']
		head 200
	end


	def new_spain_report_reader
		begin
		thespainreport_new_user_create
		thespainreport_user_roles
		set_briefings_and_stories

		# …then send some welcome e-mails…
		user = User.find_by_email(params[:email])
		
		UserMailer.delay.new_user_password_choose(user)
		UserMailer.delay.new_user_story_notifications(user)
		UserMailer.delay.new_user_catch_up(user)

		# Redirect to 
		redirect_to :back
		flash[:success] = "Welcome aboard! Check your e-mail."
		rescue
		redirect_to :back
		flash[:success] = "Try again…"
		end
	end


	def thespainreport_new_user_create
		autopassword = 'L e @ 4' + SecureRandom.hex(32)
		generate_token = SecureRandom.urlsafe_base64
		
		user = User.create!(
			email: params[:email],
			password: autopassword,
			password_confirmation: autopassword,
			password_reset_token: generate_token,
			password_reset_sent_at: Time.zone.now
			)
			
		
	end


	def thespainreport_user_roles
		user = User.find_by_email(params[:email])
		if params[:plan] == "one_story"
			user.update(
				role: 'subscriber_one_story'
				)
		elsif params[:plan] == "all_stories"
			user.update(
				role: 'subscriber_all_stories'
				)
		else
			user.update(
				access_date: Time.now + 30.days,
				role: 'reader'
				)
		end
	end


	def set_briefings_and_stories
		# Get new user and set briefing frequency…
		user = User.find_by_email(params[:email])
		user.update(
		briefing_frequency_id: 5
		)

		# …then record sign-up url in a History record
		h = History.create(
		user_id: user.id,
		article_id: params[:article_id])

		# …then add stories…
		Story.nowactive.each do |s|
			n = Notification.new
			n.story_id = s.id
			n.user_id = user.id
			n.notificationtype_id =	 1
			n.save!
		end

		Story.notnowactive.keystories.each do |s|
			n = Notification.new
			n.story_id = s.id
			n.user_id = user.id
			n.notificationtype_id =	 1
			n.save!
		end

		Story.notnowactive.notkeystories.each do |s|
			n = Notification.new
			n.story_id = s.id
			n.user_id = user.id
			n.notificationtype_id =	 2
			n.save!
		end
	end

	def subscription_details
		@user = User.find(params[:user_id])
		@stripe_customer = @user.stripe_customer_id
		
		if @user.subscriptions.any?
			@current_subscription = @user.subscriptions.last.stripe_subscription_id
			@change_subscription = Stripe::Subscription.retrieve(@current_subscription, subscription_country)
			@proration_date = Time.now.to_i
		else
		
		end
	end


	
	def resubscribe_one
		country_choice
		
		new = Stripe::Subscription.create({
			customer: @stripe_customer,
			source: @stripe_customer.source,
			items: [{plan: 'one_story'}],
		}, @apikey)
		
		redirect_to :back
		flash[:success] = "Resubscribed to One Story."
	end
	
	def resubscribe_all
		country_choice
		subscription_details
		
		new = Stripe::Subscription.create({
			customer: @stripe_customer,
			items: [{plan: 'all_stories'}],
		}, subscription_country)
		
		redirect_to :back
		flash[:success] = "Resubscribed to All Stories ."
	end
	
	def one_story
		subscription_details
		
		item_id = @change_subscription.items.data[0].id
		items = [{
			id: item_id,
			plan: "one_story",
		}]
		@change_subscription.items = items
		@change_subscription.proration_date = @proration_date
		@change_subscription.save
		
		@user.update(
			role: 'subscriber_one_story',
			access_date: Time.at(@change_subscription.current_period_end).to_datetime
		)
		
		redirect_to :back
		flash[:success] = "Now subscribed to One Story."
	end
	
	
	def all_stories
		subscription_details
		
		item_id = @change_subscription.items.data[0].id
		items = [{
			id: item_id,
			plan: "all_stories",
		}]
		@change_subscription.items = items
		@change_subscription.proration_date = @proration_date
		@change_subscription.save
		
		@user.update(
			role: 'subscriber_all_stories',
			access_date: Time.at(@change_subscription.current_period_end).to_datetime
		)
		
		redirect_to :back
		flash[:success] = "Now subscribed to All Stories."
	end
	
	def buy_more_users
		subscription_details

		item_id = @change_subscription.items.data[0].id
		items = [{
			id: item_id,
			quantity: 10
		}]
		@change_subscription.items = items
		@change_subscription.save
		
		redirect_to :back
		flash[:success] = "Now subscribed to All Stories."
	end
	
	def pause
		subscription_details
		
		item_id = @change_subscription.items.data[0].id
		items = [{
			id: item_id,
			plan: "paused",
		}]
		@change_subscription.items = items
		@change_subscription.proration_date = @proration_date
		@change_subscription.save
		
		@user.update(
			role: 'subscriber_paused',
			access_date: Time.current
		)
		
		redirect_to :back
		flash[:success] = "You have paused your subscription."
	end


	def get_subscription_history
		subscription_details
		@full_customer = Stripe::Customer.retrieve(@stripe_customer, subscription_country)
		@allsubscriptions = Stripe::Subscription.list({:customer => @stripe_customer, :status => 'all'}, subscription_country)
		
		subs = @allsubscriptions
		subs.each do |sub|
			puts sub.id
			if @user.subscriptions.where(stripe_subscription_id: sub.id).exists?
				puts 'Subscription already exists'
				s = Subscription.find_by_stripe_subscription_id(sub.id)
				s.update(
					stripe_currency: sub.plan.currency,
					stripe_status: sub.status,
					stripe_subscription_created: Time.at(sub.created).to_datetime
				)
				if s.stripe_status == 'canceled'
					@user.update(
						access_date: Time.at(sub.canceled_at).to_datetime
					)
					s.update(
						stripe_subscription_current_period_end_date: Time.at(sub.canceled_at).to_datetime
					)
				else
					@user.update(
						access_date: Time.at(sub.current_period_end).to_datetime
					)
					s.update(
						stripe_subscription_current_period_end_date: Time.at(sub.current_period_end).to_datetime
					)
				end
				
			else
				s = Subscription.new
				s.user_id = @user.id
				s.stripe_customer_id = sub.customer
				s.stripe_subscription_id = sub.id
				s.stripe_subscription_created = sub.created
				s.stripe_subscription_email = @user.email
				s.stripe_subscription_plan = sub.plan.name
				s.stripe_subscription_amount = sub.plan.amount
				s.stripe_subscription_interval = sub.plan.interval
				s.stripe_subscription_quantity = sub.quantity
				s.stripe_subscription_tax_percent = sub.tax_percent
				s.stripe_subscription_credit_card_country = @full_customer.sources.data[0].country
				s.stripe_subscription_current_period_start_date = Time.at(sub.current_period_start).to_datetime
				s.stripe_subscription_current_period_end_date = Time.at(sub.current_period_end).to_datetime
				s.stripe_currency = sub.plan.currency
				s.stripe_status = sub.status
				s.stripe_subscription_ip = ''
				s.stripe_subscription_ip_country = @full_customer.sources.data[0].country
				s.stripe_subscription_ip_country_name = ''
				s.save!
			end
		end
			
		invs = @full_customer.invoices
		invs.each do |inv|
			if @user.invoices.where(stripe_invoice_id: inv.id).exists?
				i = Invoice.find_by_stripe_invoice_id(inv.id)
				if i.status == 'verified'
					puts 'Invoice already verified'
				else
					i.update(
						stripe_invoice_currency: inv.currency,
						stripe_invoice_number: inv.number,
						stripe_invoice_interval: inv.lines.data[0].plan.interval,
						paid: inv.paid,
						status: 'unverified'
					)
				end
			else
				i = Invoice.new
				i.user_id = @user.id
				i.subscription_id = inv.subscription
				i.stripe_invoice_id = inv.id
				i.stripe_invoice_number = inv.number
				i.stripe_invoice_date = Time.at(inv.date).to_datetime
				i.stripe_invoice_item = inv.lines.data[0].plan.name
				i.stripe_invoice_quantity = inv.lines.data[0].quantity
				i.stripe_invoice_price = inv.lines.data[0].plan.amount
				i.stripe_invoice_subtotal = inv.subtotal
				i.stripe_invoice_credit_card_country = @full_customer.sources.data[0].country
				i.stripe_invoice_tax_percent = inv.tax_percent
				i.stripe_invoice_tax_amount = inv.tax
				i.stripe_invoice_currency = inv.currency
				i.stripe_invoice_interval = inv.lines.data[0].plan.interval
				i.stripe_invoice_total = inv.total
				i.stripe_invoice_ip_country_code = ''
				i.stripe_invoice_ip_country_code_2 = ''
				i.paid = inv.paid
				i.status = 'unverified'
				i.save!
			end
		end
			
		redirect_to :back
		flash[:success] = "All up-to-date."
	end


	def unsubscribe
		user = User.find_by_update_token(params[:id])
		user.email = 'deleted-' + SecureRandom.hex(10)
		user.role = 'deleted'
		user.save(:validate => false)

		session[:user_id] = nil
		reset_session

		redirect_to root_url
		flash[:success] = "Thank you: you have unsubscribed."
	end

	def unsubscribe_by_staff
		user = User.find_by_id(params[:id])
		user.email = 'deleted-' + SecureRandom.hex(10)
		user.role = 'deleted'
		user.save(:validate => false)

		redirect_to :back
		flash[:success] = "Thank you: you have unsubscribed."
	end

	def link_by_account_boss
		if User.exists?(email: params[:email])
		
		else
			thespainreport_new_user_create
			set_briefings_and_stories
		end
		
		user = User.find_by_email(params[:email])
		s = Subscription.find_by_id(params[:subscription_id])
		
		if ["All Stories", "all_stories"].include?(s.stripe_subscription_plan)
			new_role = 'subscriber_all_stories'
		elsif ["One Story", "one_story"].include?(s.stripe_subscription_plan)
			new_role = 'subscriber_one_story'
		end
		
		user.update(
			account_id: params[:account_id],
			account_role: 'account_member',
			account_subscription_id: s.id,
			role: new_role,
			access_date: s.stripe_subscription_current_period_end_date
		)
	
		redirect_to :back
		flash[:success] = "User linked."
	end
	
	def unlink_by_account_boss
		user = User.find_by_id(params[:id])
		user.update(
			account_id: '',
			account_role: '',
			role: 'reader',
			access_date: Time.current
		)
	
		redirect_to :back
		flash[:success] = "User unlinked."
	end

  def new_spain_report_member
    # Generate tokens for passwords and reset links
    autopassword = 'L e @ 4' + SecureRandom.hex(32)
    generate_token = SecureRandom.urlsafe_base64
    
    # Create the new member in users table
    user = User.create!(
     email: params[:email],
     sign_up_url: params[:sign_up_url],
     story_ids: params[:story_ids],
     article_ids: params[:article_ids],
     password: autopassword,
     password_confirmation: autopassword,
     password_reset_token: generate_token,
     password_reset_sent_at: Time.zone.now
    )
    
    # E-mail new member to confirme e-mail & choose password
    UserMailer.delay.registration_confirmation(user)
    UserMailer.delay.password_choose(user)
    UserMailer.delay.new_user_stories(user)
    
    # Redirect to 
    redirect_to :back
    flash[:success] = "Welcome aboard! Check your e-mail."
    return
    flash[:success] = "Welcome aboard! Check your e-mail."
  end
  
  def update_credit_card
    token = params[:stripeToken]
    customer_id = params[:customer_id]
    old_card = params[:old_card]
    
    begin
    stripe_customer = Stripe::Customer.retrieve(customer_id, subscription_country)
    stripe_customer.source = token
    stripe_customer.save

    stripe_customer = Stripe::Customer.retrieve(customer_id, subscription_country)
    user = User.find(params[:user_id])
    user.credit_card_id = stripe_customer.sources.data[0].id
    user.credit_card_brand = stripe_customer.sources.data[0].brand
    user.credit_card_country = stripe_customer.sources.data[0].country
    user.credit_card_last4 = stripe_customer.sources.data[0].last4
    user.credit_card_expiry_month = stripe_customer.sources.data[0].exp_month
    user.credit_card_expiry_year = stripe_customer.sources.data[0].exp_year
    user.save!
    redirect_to :back
    flash[:success] = "Well done! New credit card saved."
    
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]
      
      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Code is: #{err[:code]}"
      # param is '' in this case
      puts "Param is: #{err[:param]}"
      puts "Message is: #{err[:message]}"
      flash[:error] = "#{err[:message]}"
      redirect_to :back
    rescue Stripe::InvalidRequestError => e
      flash[:error] = "Invalid request to payment processor. Please try again."
      redirect_to :back
    rescue Stripe::AuthenticationError => e
      flash[:error] = "Could not connect to payment processor. Please try again."
      redirect_to :back
    rescue Stripe::APIConnectionError => e
      flash[:error] = "Could not connect to payment processor. Please try again."
      redirect_to :back
    rescue Stripe::StripeError => e
      flash[:error] = "General payment processor problem. Please try again."
      redirect_to :back
    rescue => e
      flash[:error] = "Unspecified problem. Please contact subscriptions@thespainreport.com."
      redirect_to :back
    end
    
  end
  
  def cancel_subscription
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    else
      tsr_subscription = Subscription.find(params[:tsr_subscription_id])
      subscription_id = params[:cancel_subscription_id]
      subscription = Stripe::Subscription.retrieve(subscription_id)
      subscription.delete
      tsr_subscription.is_active = false
      tsr_subscription.save!
      redirect_to :back
    end
  end
  
  # GET /subscriptions
  # GET /subscriptions.json
  def index
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # GET /subscriptions/new
  def new
  	@taxes = Tax.all.order('tax_country_name ASC')
  end
  
  # GET /subscriptions/spain
  def spain
  	@taxes = Tax.all.order('tax_country_name ASC')
  end
  
  # GET /subscriptions/prepay
  def prepay
  	@taxes = Tax.all.order('tax_country_name ASC')
  end

	# GET /subscriptions/prepay
  def prepay_spain
  	@taxes = Tax.all.order('tax_country_name ASC')
  end


  # GET /subscriptions/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
  end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_subscription
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def subscription_params
			params.require(:subscription).permit(
				:user_id,
				:stripe_customer_id,
				:stripe_currency,
				:stripe_status,
				:stripe_subscription_created,
				:stripe_subscription_id,
				:stripe_subscription_ip,
				:stripe_subscription_ip_country,
				:stripe_subscription_ip_country_name,
				:stripe_subscription_credit_card_country,
				:stripe_subscription_email,
				:stripe_subscription_plan,
				:stripe_subscription_amount,
				:stripe_subscription_interval,
				:stripe_subscription_quantity,
				:stripe_subscription_tax_percent,
				:stripe_subscription_trial_end,
				:stripe_subscription_current_period_start_date,
				:stripe_subscription_current_period_end_date,
				:is_active
				)
		end
end