#### 8 Country Methods
#### xx New Reader
#### 101 Prepayments
#### 242 Subscriptions
#### 388 Common Elements
#### xxx Subscription Webhooks
#### 647 Get Subscription History
#### xxx REST methods

class SubscriptionsController < ApplicationController
	before_action :set_subscription, only: [:show, :edit, :update, :destroy]
	skip_before_action :verify_authenticity_token, only: :stripe_hooks
	protect_from_forgery except: :stripe_hooks

	#### COUNTRY RELATED METHODS: 1) country_choice, 2) subscription_country, 3) new_credit_card ####
	#### STARTS country_choice ####
	def country_choice
		if params[:ip_country_code] == "ES"
			@apikey = {:api_key => Rails.configuration.stripe[:secret_spain_key]}
			@currency = 'eur'
			@prefix = 'ES-'
			@howmanyinvoices = Invoice.spain.where('extract(year from created_at) = ?', Time.current.year).count
		else
			@apikey = {:api_key => Rails.configuration.stripe[:secret_key]}
			@currency = 'gbp'
			@prefix = ''
			@howmanyinvoices = Invoice.notspain.where('extract(year from created_at) = ?', Time.current.year).count
		end
		
		@invoice_number = @prefix + Time.current.year.to_s + (@howmanyinvoices + 1).to_s.rjust(8, '0')
	end
	#### ENDS country_choice ####
	
	
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
	
	#### STARTS new_credit_card ####
	def new_credit_card
		u = User.find_by_email(params[:email])
		
		if params[:ip_country_code] == "ES"
			u.update(
				credit_card_id_spain: @customer.sources.data[0].id,
				credit_card_brand_spain: @customer.sources.data[0].brand,
				credit_card_country_spain: @customer.sources.data[0].country,
				credit_card_last4_spain: @customer.sources.data[0].last4,
				credit_card_expiry_month_spain: @customer.sources.data[0].exp_month,
				credit_card_expiry_year_spain: @customer.sources.data[0].exp_year
				)
		else
			u.update(
				credit_card_id: @customer.sources.data[0].id,
				credit_card_brand: @customer.sources.data[0].brand,
				credit_card_country: @customer.sources.data[0].country,
				credit_card_last4: @customer.sources.data[0].last4,
				credit_card_expiry_month: @customer.sources.data[0].exp_month,
				credit_card_expiry_year: @customer.sources.data[0].exp_year
				)
		end
	end
	#### ENDS new_credit_card ####
	
	#### STARTS existing_customer ####
	def existing_customer
		if params[:ip_country_code] == 'ES' && current_user.stripe_customer_id_spain?
			@customer = current_user.stripe_customer_id_spain
		elsif params[:ip_country_code] != 'ES' && current_user.stripe_customer_id?
			@customer = current_user.stripe_customer_id
		else
		end
	end
	#### ENDS existing_customer ####
	
	#### STARTS update_credit_card ####
		def update_credit_card
		token = params[:stripeToken]
		old_card = params[:old_card]
		
		begin
		c = Stripe::Customer.retrieve(@customer, @apikey)
		c.source = token
		c.save

		c = Stripe::Customer.retrieve(@customer, @apikey)
		u = User.find_by_email(params[:email])
		
		if params[:ip_country_code] == "ES"
			u.credit_card_id_spain = c.sources.data[0].id
			u.credit_card_brand_spain = c.sources.data[0].brand
			u.credit_card_country_spain = c.sources.data[0].country
			u.credit_card_last4_spain = c.sources.data[0].last4
			u.credit_card_expiry_month_spain = c.sources.data[0].exp_month
			u.credit_card_expiry_year_spain = c.sources.data[0].exp_year
			u.save!
		else
			u.credit_card_id = c.sources.data[0].id
			u.credit_card_brand = c.sources.data[0].brand
			u.credit_card_country = c.sources.data[0].country
			u.credit_card_last4 = c.sources.data[0].last4
			u.credit_card_expiry_month = c.sources.data[0].exp_month
			u.credit_card_expiry_year = c.sources.data[0].exp_year
			u.save!
		end
		
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
	#### ENDS update_credit_card ####
	
	#### STARTS new_subscription_customer ####
	def new_subscription_customer
		@customer = Stripe::Customer.create({
			:source => @token,
			:description => @email_address
			}, @apikey)
	end
	#### ENDS new_subscription_customer ####
	
	#### STARTS new_subscription_charge ####
	def new_subscription_charge
		@s = Stripe::Subscription.create({
			customer: @customer,
			quantity: @how_many,
			plan: params[:plan],
			coupon: discount_code,
			tax_percent: @tax_percent
		}, @apikey)
	end
	
	def discount_code
		if params[:discount] == '10'
			'users-10'
		elsif params[:discount] == '20'
			'users-20'
		elsif params[:discount] == '30'
			'users-30'
		else
		end
	end
	#### ENDS new_subscription_charge ####
	
	#### STARTS new_prepayment_customer ####
	def new_prepayment_customer
		@customer = Stripe::Customer.create({
			:source => @token,
			:description => @email_address
			}, @apikey)
	end
	#### ENDS new_prepayment_customer ####
	
	#### STARTS new_prepayment_charge ####
	def new_prepayment_charge
		charge = Stripe::Charge.create({
			:customer => @customer,
			:description => 'One-time pre-payment',
			:amount => @amount,
			:currency => @currency
			}, @apikey)
	end
	#### ENDS new_prepayment_charge ####
	
	#### STARTS new_customer_id_date ####
	def new_customer_id_date
		u = User.find_by_email(params[:email])
		
		if params[:ip_country_code] == 'ES'
			u.update(
			stripe_customer_id_spain: @customer.id,
			becomes_customer_date_spain: Time.at(@customer.created).to_datetime
			)
		elsif params[:ip_country_code] != 'ES'
			u.update(
			stripe_customer_id: @customer.id,
			becomes_customer_date: Time.at(@customer.created).to_datetime
			)
		else
		end
	end
	#### ENDS new_customer_id_date ####
	#### ENDS COUNTRY METHODS ####
	###############################################
	
	
	
	###############################################
	#### READERS: 1) new_spain_report_reader
	#### STARTS new_spain_report_reader ####
	def new_spain_report_reader
		begin
		# Create the user, assign role, set notifications…
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
	#### ENDS new_spain_report_reader ####
	#### ENDS READERS ####
	#########################################
	
	
	
	#########################################
	#### PREPAYMENTS: 1) new_prepayment, 2) set_one_time_details ####
	#### STARTS new_prepayment ####
	def new_prepayment
		# Get form elements
		@token = params[:stripeToken]
		@email_address = params[:email]
		@amount = params[:amount]
		ip_address = params[:ip_address]
		ip_country_code = params[:ip_country_code]
		ip_country_name = params[:ip_country_name]
		
		# Access country stuff
		country_choice
		
		# Who is trying to make a payment? Logged-in/not, existing/current, existing_uk/not, existing_spain/not, brand new
		if User.exists?(email: params[:email]) 
			if current_user.nil?
				redirect_to :back
				flash[:success] = "Please log in to continue."
			elsif current_user.email != params[:email]
				redirect_to :back
				flash[:success] = "Please use your own email."
			elsif current_user.email == params[:email]
				if params[:ip_country_code] == 'ES' && current_user.stripe_customer_id_spain.blank? || params[:ip_country_code] != 'ES' && current_user.stripe_customer_id.blank?
					new_prepayment_customer
					
					new_prepayment_charge
					new_customer_id_date
					new_credit_card
					
					set_one_time_details
					thespainreport_user_roles
					
					redirect_to :back
					flash[:success] = "Pre-payment successful."
				elsif params[:ip_country_code] == 'ES' && current_user.stripe_customer_id_spain? && current_user.credit_card_id_spain.blank? || params[:ip_country_code] != 'ES' && current_user.stripe_customer_id? && current_user.credit_card_id.blank?
					existing_customer
					
					new_prepayment_charge
					update_credit_card
					
					set_one_time_details
					thespainreport_user_roles
					
					redirect_to :back
					flash[:success] = "Pre-payment successful."
				elsif params[:ip_country_code] == 'ES' && current_user.stripe_customer_id_spain? && current_user.credit_card_id_spain? || params[:ip_country_code] != 'ES' && current_user.stripe_customer_id? && current_user.credit_card_id?
					existing_customer
					
					new_prepayment_charge
				
					set_one_time_details
					thespainreport_user_roles
				
					redirect_to :back
					flash[:success] = "Pre-payment successful."
				end
			else
			end
		else
			new_prepayment_customer
			new_prepayment_charge
			
			thespainreport_new_user_create
			thespainreport_user_roles
			set_briefings_and_stories
			new_customer_id_date
			new_credit_card
			
			set_one_time_details
			
			redirect_to :back
			flash[:success] = "Pre-payment successful."
		end
	end
	##### ENDS new_prepayment ####
	
	##### STARTS set_one_time_details ####
	def set_one_time_details
		country_choice
		@one_time_date = Time.current + params[:forward].to_i.months
		
		user_account
		
		u = User.find_by_email(params[:email])
		u.update(
			access_date: @one_time_date
		)
		
		# A new subscription on TSR
		s = Subscription.new
		s.user_id = u.id
		if params[:ip_country_code] == 'ES'
			s.stripe_customer_id = u.stripe_customer_id_spain
		elsif params[:ip_country_code] != 'ES'
			s.stripe_customer_id = u.stripe_customer_id
		else
		end
		s.stripe_subscription_type = 'One-time pre-payment'
		s.stripe_subscription_email = u.email
		s.stripe_subscription_plan = params[:plan]
		s.stripe_subscription_amount = params[:amount]
		s.stripe_subscription_interval = 'months'
		s.stripe_subscription_quantity = params[:quantity]
		s.stripe_subscription_howlong = params[:forward]
		s.discount = params[:discount]
		s.stripe_subscription_tax_percent = params[:ts]
		s.stripe_subscription_ip = params[:ip_address]
		s.stripe_subscription_ip_country = params[:ip_country_code]
		s.stripe_subscription_ip_country_name = params[:ip_country_name]
		if params[:ip_country_code] == 'ES'
			s.stripe_subscription_credit_card_country = u.credit_card_country_spain
		elsif params[:ip_country_code] != 'ES'
			s.stripe_subscription_credit_card_country = u.credit_card_country
		else
		end
		s.stripe_subscription_current_period_start_date = Time.current.to_datetime
		s.stripe_subscription_created = Time.current.to_datetime
		s.stripe_subscription_current_period_end_date = @one_time_date
		s.stripe_currency = @currency
		s.stripe_status = 'active'
		s.save!
		
		# A new one-time invoice on TSR
		i = Invoice.new
		i.number = @invoice_number
		i.user_id = u.id
		i.subscription_id = s.id
		i.stripe_invoice_id = 'One-time invoice'
		i.stripe_invoice_number = 'One-time invoice'
		i.stripe_invoice_date = Time.current.to_datetime
		i.stripe_invoice_item = 'One-time pre-payment'
		i.stripe_invoice_quantity = params[:quantity]
		i.howlong = params[:forward]
		i.stripe_invoice_price = params[:base_price]
		i.discount = params[:discount]
		i.stripe_invoice_subtotal = params[:subtotal]
		if params[:ip_country_code] == 'ES'
			i.stripe_invoice_credit_card_country = u.credit_card_country_spain
		elsif params[:ip_country_code] != 'ES'
			i.stripe_invoice_credit_card_country = u.credit_card_country
		else
		end
		i.stripe_invoice_tax_percent = params[:ts]
		i.stripe_invoice_tax_amount = params[:tax_amount]
		i.stripe_invoice_currency = @currency
		i.stripe_invoice_interval = 'month'
		i.stripe_invoice_total = params[:amount]
		i.stripe_invoice_ip_country_code = params[:ip_country_code]
		i.paid = true
		i.status = 'unverified'
		i.save!
	end
	#### ENDS set_one_time_details ####
	#### ENDS PREPAYMENTS ####
	##########################################
	
	
	
	##########################################
	#### SUBSCRIPTIONS: 1) new_subscription, 2) subscription_access_date, 3) create_tsr_subscription_invoice ####
	#### STARTS new_subscription ####
	def new_subscription
		# Get the credit card details from the form and generate stripeToken
		@token = params[:stripeToken]
		@email_address = params[:email]
		@tax_percent = params[:ts]
		@how_many = params[:quantity]
		@ip_address = params[:ip_address]
		@ip_country_code = params[:ip_country_code]
		@ip_country_name = params[:ip_country_name]
		
		# Access country stuff
		country_choice
		
		if User.exists?(email: params[:email]) 
			if current_user.nil?
				redirect_to :back
				flash[:success] = "Please log in to continue."
			elsif current_user.email != params[:email]
				redirect_to :back
				flash[:success] = "Please use your own email."
			elsif current_user.email == params[:email]
				if params[:ip_country_code] == 'ES' && current_user.stripe_customer_id_spain.blank? || params[:ip_country_code] != 'ES' && current_user.stripe_customer_id.blank?
					# No Stripe customer exists, so create one and add them to a subscription plan
					new_subscription_customer
					new_subscription_charge
					new_customer_id_date
					
					# Update existing user, relate to Stripe
					thespainreport_user_roles
					subscription_access_date
					
					# Attach a new credit card to the new user
					new_credit_card
					
					# Make an account for them
					user_account
					
					# Create the subscription and invoice on TSR
					create_tsr_subscription_invoice
					
					# All done, good job
					redirect_to :back
					flash[:success] = "Subscription successful."
				elsif params[:ip_country_code] == 'ES' && current_user.stripe_customer_id_spain? && current_user.credit_card_id_spain.blank? || params[:ip_country_code] != 'ES' && current_user.stripe_customer_id? && current_user.credit_card_id.blank?
					# User already exists and has a Stripe customer number for the purchase country
					existing_customer
					
					# But has no attached credit card, so…
					update_credit_card
					
					# And create new subscription…
					new_subscription_charge
					
					# Related to Stripe, now has a credit card, so update role and access date…
					thespainreport_user_roles
					subscription_access_date
					
					# Make sure they are attached to an account
					user_account
					
					# Create the subscription and invoice on TSR
					create_tsr_subscription_invoice
					
					# All done, good job
					redirect_to :back
					flash[:success] = "Re-subscription successful."
				elsif params[:ip_country_code] == 'ES' && current_user.stripe_customer_id_spain? && current_user.credit_card_id_spain? || params[:ip_country_code] != 'ES' && current_user.stripe_customer_id? && current_user.credit_card_id?
					# User already exists and has a Stripe customer number for the purchase country
					existing_customer
					
					# Already has a credit card attached
					
					# So just create new subscription…
					new_subscription_charge
					
					# No need to relate to Stripe again or add a card, but update role and access date
					thespainreport_user_roles
					subscription_access_date
					
					# Make sure they are attached to an account
					user_account
					
					# Create the subscription and invoice on TSR
					create_tsr_subscription_invoice
					
					# All done, good job
					redirect_to :back
					flash[:success] = "Subscription successful."
				end
			else
			end
		else
			begin
				# Create a new Stripe customer and add them to a subscription plan
				new_subscription_customer
				
				# Basic new user set up, then relate to Stripe
				thespainreport_new_user_create
				thespainreport_user_roles
				set_briefings_and_stories
				new_customer_id_date
				
				new_subscription_charge
				subscription_access_date
				
				# Add a new credit card
				new_credit_card
				
				# Make an account for them
				user_account
				
				# Create the subscription on TSR
				create_tsr_subscription_invoice
				
				# Send a thank-you e-mail
				u = User.find_by_email(params[:email])
				UserMailer.delay.new_subscriber_thank_you(u)
				
				# All done, good job
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
	#### ENDS new_subscription ####
	
	#### STARTS subscription_access_date ####
	def subscription_access_date
		u = User.find_by_email(params[:email])
		
		u.update(
			access_date: Time.at(@s.current_period_end).to_datetime
		)
	end
	#### ENDS subscription_access_date ####
	
	#### STARTS create_tsr_subscription_invoice ####
	def create_tsr_subscription_invoice
		u = User.find_by_email(params[:email])
		
		s = Subscription.new
		s.user_id = u.id
		if params[:ip_country_code] == 'ES'
			s.stripe_customer_id = u.stripe_customer_id_spain
			s.stripe_subscription_credit_card_country = u.credit_card_country_spain
		elsif params[:ip_country_code] != 'ES'
			s.stripe_customer_id = u.stripe_customer_id
			s.stripe_subscription_credit_card_country = u.credit_card_country
		else
		end
		s.stripe_subscription_id = @s.id
		s.stripe_subscription_type = 'Recurring subscription'
		s.stripe_subscription_email = @email_address
		s.stripe_subscription_plan = @s.plan.name
		s.stripe_subscription_amount = @s.plan.amount
		s.stripe_subscription_interval = @s.plan.interval
		s.stripe_subscription_quantity = @s.quantity
		s.stripe_subscription_howlong = 1
		s.discount = discount_code_subscription
		s.stripe_subscription_tax_percent = @s.tax_percent
		s.stripe_subscription_ip = @ip_address
		s.stripe_subscription_ip_country = @ip_country_code
		s.stripe_subscription_ip_country_name = @ip_country_name
		s.stripe_subscription_current_period_start_date = Time.at(@s.current_period_start).to_datetime
		s.stripe_subscription_current_period_end_date = Time.at(@s.current_period_end).to_datetime
		s.stripe_subscription_created = Time.current.to_datetime
		s.stripe_currency = @currency
		s.stripe_status = 'active'
		s.save!
		
		# Create the first invoice for that subscription record on TSR
		stripeinvs = Stripe::Invoice.all({:customer => @customer, :subscription => @s.id }, @apikey)
		stripeinvs.each do |stripeinv|
			i = Invoice.new
			i.number = @invoice_number
			i.user_id = u.id
			i.subscription_id = @s.id
			i.stripe_invoice_id = stripeinv.id
			i.stripe_invoice_number = stripeinv.number
			i.stripe_invoice_date = Time.at(stripeinv.date).to_datetime
			i.stripe_invoice_item = stripeinv.lines.data[0].plan.name
			i.stripe_invoice_quantity = stripeinv.lines.data[0].quantity
			i.howlong = 1
			i.discount = discount_code_subscription
			i.stripe_invoice_price = stripeinv.lines.data[0].plan.amount
			i.stripe_invoice_subtotal = params[:subtotal]
			if params[:ip_country_code] == 'ES'
				i.stripe_invoice_credit_card_country = u.credit_card_country_spain
			elsif params[:ip_country_code] != 'ES'
				i.stripe_invoice_credit_card_country = u.credit_card_country
			else
			end
			i.stripe_invoice_ip_country_code = @ip_country_code
			i.stripe_invoice_tax_percent = stripeinv.tax_percent
			i.stripe_invoice_tax_amount = stripeinv.tax
			i.stripe_invoice_total = stripeinv.total
			i.stripe_invoice_currency = @currency
			i.stripe_invoice_interval = stripeinv.lines.data[0].plan.interval
			i.paid = stripeinv.paid
			i.status = 'unverified'
			i.save!
		end
	end
	
	def discount_code_subscription
		if params[:discount] == '10'
			10
		elsif params[:discount] == '20'
			20
		elsif params[:discount] == '30'
			30
		else
			0
		end
	end
	#### ENDS create_tsr_subscription_invoice ####
	#### ENDS SUBSCRIPTIONS  ####
	###################################################
	
	
	###################################################
	#### COMMON ELEMENTS:  ####
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
	
	def user_account
		u = User.find_by_email(params[:email])
		
		if User.exists?(email: params[:email]) && u.account
			u.update(
				account_role: 'account_boss'
			)
		else
			a = Account.create(
				name: params[:email]
			)
			
			u.update(
				account_id: a.id,
				account_role: 'account_boss'
			)
		end
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
		u = User.find_by_email(params[:email])
		u.update(
		briefing_frequency_id: 5
		)

		# …then record sign-up url in a History record
		h = History.create(
		user_id: u.id,
		article_id: params[:article_id])

		# …then add stories…
		Story.nowactive.each do |s|
			n = Notification.new
			n.story_id = s.id
			n.user_id = u.id
			n.notificationtype_id = 1
			n.save!
		end

		Story.notnowactive.keystories.each do |s|
			n = Notification.new
			n.story_id = s.id
			n.user_id = u.id
			n.notificationtype_id = 1
			n.save!
		end

		Story.notnowactive.notkeystories.each do |s|
			n = Notification.new
			n.story_id = s.id
			n.user_id = u.id
			n.notificationtype_id = 2
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
	
	##### STRIPE WEBHOOKS ####
	def stripe_hooks
		event = JSON.parse(request.body.read)
		puts 'Event type: ' + event['type']
		puts 'Event id: ' + event['id']
		puts 'Event date: ' + Time.at(event['created']).to_datetime.to_s
		puts 'Customer: ' + event['data']['object']['customer']
		head 200
	end
	
	##### RESUBSCRIPTIONS ####
	def resubscribe_one
		country_choice
		subscription_details
		
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
				:stripe_subscription_id,
				:stripe_currency,
				:stripe_status,
				:stripe_subscription_type,
				:stripe_subscription_created,
				:stripe_subscription_ip,
				:stripe_subscription_ip_country,
				:stripe_subscription_ip_country_name,
				:stripe_subscription_credit_card_country,
				:stripe_subscription_email,
				:stripe_subscription_plan,
				:stripe_subscription_amount,
				:stripe_subscription_interval,
				:stripe_subscription_quantity,
				:stripe_subscription_howlong,
				:stripe_subscription_tax_percent,
				:stripe_subscription_trial_end,
				:stripe_subscription_current_period_start_date,
				:stripe_subscription_current_period_end_date,
				:is_active,
				:discount
				)
		end
end