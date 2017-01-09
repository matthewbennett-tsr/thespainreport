class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  
  def new_subscription
    # Get the credit card details from the form and generate stripeToken
    token = params[:stripeToken]
    email_address = params[:email]
    tax_percent = params[:ts]
    how_many = params[:quantity]
    ip_address = params[:ip_address]
    ip_country_code = params[:ip_country_code]
    ip_country_name = params[:ip_country_name]
    
    begin
      # Create a new Stripe customer and add them to a subscription plan
      customer = Stripe::Customer.create(
        :source => token,
        :description => email_address,
        :plan => params[:plan],
        :tax_percent => tax_percent,
        :quantity => how_many
        )
        
      # Add Stripe customer details i) to an existing reader or ii) to a new Spain Report member
      if user = User.find_by_email(params[:email])
        user.stripe_customer_id = customer.id
        user.becomes_customer_date = Time.at(customer.created).to_datetime
        user.credit_card_id = customer.sources.data[0].id
        user.credit_card_brand = customer.sources.data[0].brand
        user.credit_card_country = customer.sources.data[0].country
        user.credit_card_last4 = customer.sources.data[0].last4
        user.credit_card_expiry_month = customer.sources.data[0].exp_month
        user.credit_card_expiry_year = customer.sources.data[0].exp_year
        user.role = 'subscriber'
        user.save!
        subscription = Subscription.new(
          user_id: user.id,
          stripe_customer_id: customer.id,
          stripe_subscription_id: customer.subscription.data[0].id,
          stripe_subscription_credit_card_country: customer.sources.data[0].country
          )
        subscription.save!
        redirect_to :back
      else
        new_spain_report_member
        user = User.find_by_email(params[:email])
        user.stripe_customer_id = customer.id
        user.becomes_customer_date = Time.at(customer.created).to_datetime
        user.credit_card_id = customer.sources.data[0].id
        user.credit_card_brand = customer.sources.data[0].brand
        user.credit_card_country = customer.sources.data[0].country
        user.credit_card_last4 = customer.sources.data[0].last4
        user.credit_card_expiry_month = customer.sources.data[0].exp_month
        user.credit_card_expiry_year = customer.sources.data[0].exp_year
        user.role = 'subscriber'
        user.save!
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
        subscription.save!
        stripeinvs = Stripe::Invoice.all(:customer => user.stripe_customer_id)
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
      end
      flash[:success] = "Thanks for subscribing to The Spain Report! Check your e-mail."
      UserMailer.delay.thank_you_for_subscribing(user)
      
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
      redirect_to '/subscriptions/new'
    rescue Stripe::InvalidRequestError => e
      flash[:error] = "Invalid request to payment processor. Please try again."
      redirect_to '/subscriptions/new'
    rescue Stripe::AuthenticationError => e
      flash[:error] = "Could not connect to payment processor. Please try again."
      redirect_to '/subscriptions/new'
    rescue Stripe::APIConnectionError => e
      flash[:error] = "Could not connect to payment processor. Please try again."
      redirect_to '/subscriptions/new'
    rescue Stripe::StripeError => e
      flash[:error] = "General payment processor problem. Please try again."
      redirect_to '/subscriptions/new'
    rescue => e
      flash[:error] = "Unspecified problem. Please contact subscriptions@thespainreport.com."
      redirect_to '/subscriptions/new'
    end
  end
  
  def new_spain_report_member
    # Generate tokens for passwords and reset links
    autopassword = 'L e @ 4' + SecureRandom.hex(32)
    generate_token = SecureRandom.urlsafe_base64
    
    # Create the new member in users table
    user = User.create!(
     email: params[:email],
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
  end
  
  # GET /subscriptions
  # GET /subscriptions.json
  def index
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  def new
  	@taxes = Tax.all.order('tax_country_name ASC')
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
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
        :stripe_subscription_current_period_end_date
        )
    end
end