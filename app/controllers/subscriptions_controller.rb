class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  def new_subscription
    # Get the credit card details from the form and generate stripeToken
    token = params[:stripeToken]
    email_address = params[:email]
    
    begin
      # Create a new Stripe customer and add them to a subscription plan
      customer = Stripe::Customer.create(
        :source => token,
        :description => email_address,
        :plan => params[:plan],
        )
    
      # Add new Stripe customer i) to existing reader or ii) as a new Spain Report member and then link the two
      if user = User.find_by_email(params[:email])
        user.stripe_customer_id = customer.id
        user.role = 'subscriber'
        user.save!
      else
        new_spain_report_member
        user = User.find_by_email(params[:email])
        user.stripe_customer_id = customer.id
        user.role = 'subscriber'
        user.save!  
      end
      
      redirect_to '/subscriptions/new'
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
      flash[:error] = "There has been a problem. Please try again."
      redirect_to '/subscriptions/new'
    rescue Stripe::AuthenticationError => e
      flash[:error] = "Could not connect to payment processor. Please try again."
      redirect_to '/subscriptions/new'
    rescue Stripe::APIConnectionError => e
      flash[:error] = "Could not connect to payment processor. Please try again."
      redirect_to '/subscriptions/new'
    rescue Stripe::StripeError => e
      flash[:error] = "There has been a problem. Please try again."
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
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
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
    end
end
