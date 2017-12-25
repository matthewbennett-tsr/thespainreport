### Adds country selector + subscriptions/spain method
### Removes redirects from error messages
### Adds sign-up fields for new_spain_report_member
### Adds return + flash message after new_spain_report_member sign up


class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  
  def country
     if ip_country_code = "ES"
          {:api_key => Rails.configuration.stripe[:secret_spain_key]}
     else
          {:api_key => Rails.configuration.stripe[:secret_key]}
     end
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
      flash[:error] = "E-mail already taken. Please use another or log in to continue."
    elsif User.exists?(email: params[:email]) && current_user.email = params[:email]
      redirect_to :back
      flash[:success] = "Time to UPDATE your subscription."
    else
    
    begin

      # Create a new Stripe customer and add them to a subscription plan
      customer = Stripe::Customer.create({
        :source => token,
        :description => email_address,
        :plan => params[:plan],
        :tax_percent => tax_percent,
        :quantity => how_many}, country)
  
        thespainreport_new_user_create
        thespainreport_user_roles
        
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
          invoice.save!
        end
        
      redirect_to :back
      flash[:success] = "Thanks for subscribing to The Spain Report! Check your e-mail."
      UserMailer.delay.new_subscriber_thank_you(user)
      
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
    rescue Stripe::InvalidRequestError => e
      flash[:error] = "Invalid request to payment processor. Please try again."
    rescue Stripe::AuthenticationError => e
      flash[:error] = "Could not connect to payment processor. Please try again."
    rescue Stripe::APIConnectionError => e
      flash[:error] = "Could not connect to payment processor. Please try again."
    rescue Stripe::StripeError => e
      flash[:error] = "General payment processor problem. Please try again."
    rescue => e
      flash[:error] = "Unspecified problem. Please contact subscriptions@thespainreport.com."
    end
  end
end

   def thespainreport_new_user_create
    autopassword = 'L e @ 4' + SecureRandom.hex(32)
    generate_token = SecureRandom.urlsafe_base64
     
    user = User.create!(
      email: params[:email],
      article_ids: params[:article_ids],
      emailpref: 'articlesupdates',
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
         access_date: Time.now + 30.days,
         role: 'subscriber_one_story'
         )
     elsif params[:plan] == "all_stories"
       user.update(
         access_date: Time.now + 30.days,
         role: 'subscriber_all_stories'
         )
     else
       user.update(
         access_date: Time.now + 30.days,
         role: 'reader'
         )
     end
   end
   
   def new_spain_report_reader
    thespainreport_new_user_create
    thespainreport_user_roles
    
    # Create stories for new user and send some welcome e-mails
    user = User.find_by_email(params[:email])
    user.update(
    briefing_frequency: 24
    )
    
    Story.all.each do |s|
      n = Notification.new
      n.story_id = s.id
      n.user_id = user.id
      n.notificationtype_id = 1
      n.save!
    end
    
    UserMailer.delay.new_user_password_choose(user)
    UserMailer.delay.new_user_story_notifications(user)
    UserMailer.delay.new_user_catch_up(user)
    
    # Redirect to 
    redirect_to :back
    flash[:success] = "Welcome aboard! Check your e-mail."
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
    stripe_customer = Stripe::Customer.retrieve(customer_id)
    stripe_customer.sources.create(source: token)
    if stripe_customer.sources.retrieve(old_card)
      stripe_customer.sources.retrieve(old_card).delete()
    end
    stripe_customer = Stripe::Customer.retrieve(customer_id)
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