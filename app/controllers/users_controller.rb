class UsersController < ApplicationController

  def index
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      if params[:search]
      terms = params[:search].scan(/"[^"]*"|'[^']*'|[^"'\s]+/)
      query = terms.map { |term| "email ILIKE '%#{term}%'" }.join(" OR ")
      @users = User.all.where(query).order("created_at DESC")
      @latestusers = User.readers.lastfew
      @latestsubscribers = User.subscribers.lastfew
      else
      @users = User.lastfew.order ('users.role DESC, users.email ASC')
      @latestusers = User.readers.lastfew
      @latestsubscribers = User.subscribers.lastfew
      @subscribercount = User.subscribers.count
      @activesubscribercount = User.activesubscribers.count
      @straysubscribercount = User.subscribers.where('stripe_customer_id is null').count
      @readercount = User.readers.count
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end
  
  def show
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
    else
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    end
  end
  
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    elsif current_user.role == 'editor'
      @user = User.new
    else
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    end 
  end
  
  def confirm
    @user = User.new
  end
  
  def newerrors
    @user = User.new
  end
  
  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Thank you very much. Enjoy TSR!"
      redirect_to root_url
    else
      flash[:error] = "Sorry, that link is not valid."
      redirect_to root_url
    end
  end
  
  def edit
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
      if @user.stripe_customer_id == "NON-AUTOMATIC INVOICE"
      elsif @user.stripe_customer_id?
        @stripe_customer_details = Stripe::Customer.retrieve(:id => @user.stripe_customer_id)
        @stripe_invoices = Stripe::Invoice.all(:customer => @user.stripe_customer_id)
      else
      end
    else
      @user = current_user
      if @user.stripe_customer_id == "NON-AUTOMATIC INVOICE"
      elsif @user.stripe_customer_id?
        @stripe_customer_details = Stripe::Customer.retrieve(:id => @user.stripe_customer_id)
        @stripe_invoices = Stripe::Invoice.all(:customer => @user.stripe_customer_id)
      else
      end
    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
    if current_user.nil? 
      if @user.save
        UserMailer.delay.registration_confirmation(@user)
        format.html { redirect_to :action => 'confirm' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :newerrors, notice: 'There was a PROBLEM…!' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    elsif current_user.role == 'editor'
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
        flash[:notice] = "Great, you added a new member."
      else
        format.html { render :newerrors, notice: 'There was a PROBLEM…!' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    else
      
    end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
      if @user.stripe_customer_id == "NON-AUTOMATIC INVOICE"
      elsif @user.stripe_customer_id?
        @stripe_customer_details = Stripe::Customer.retrieve(:id => @user.stripe_customer_id)
        @stripe_invoices = Stripe::Invoice.all(:customer => @user.stripe_customer_id)
      else
      end
      respond_to do |format|
        if @user.update(user_params)
          format.html { render :edit}
          format.json { render :edit, status: :ok, location: @user }
          flash[:notice] = "Well done, updates successful!"
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      @user = current_user
      if @user.stripe_customer_id == "NON-AUTOMATIC INVOICE"
      elsif @user.stripe_customer_id?
        @stripe_customer_details = Stripe::Customer.retrieve(:id => @user.stripe_customer_id)
        @stripe_invoices = Stripe::Invoice.all(:customer => @user.stripe_customer_id)
      else
      end
      respond_to do |format|
        if @user.update(user_params)
          format.html { render :edit}
          format.json { render :edit, status: :ok, location: @user }
          flash[:notice] = "Well done, updates successful!"
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:allow_access, :created_at, :email, :name, :bio, :role, :emailpref, :twitter, :sign_up_url, :password, :password_confirmation, :reset_token, :stripe_customer_id)
    end

end
