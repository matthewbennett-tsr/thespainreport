class UsersController < ApplicationController

  def index
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    elsif current_user.role == 'editor'
      if params[:search]
      terms = params[:search].scan(/"[^"]*"|'[^']*'|[^"'\s]+/)
      query = terms.map { |term| "email ILIKE '%#{term}%'" }.join(" OR ")
      @users = User.all.where(query).order("created_at DESC")
      @latestusers = User.readers.lastfew
      @latestsubscribers = User.totalsubscribers.lastfew
      else
      @subscribers = User.totalsubscribers.lastfew
      @readers = User.readers.lastfew
      @guests = User.guests.lastfew
      @deleted = User.deleted.lastfew
      @subscribercount = User.totalsubscribers.count
      @onestorysubscribers = User.onestorysubscribers.count
      @allstorysubscribers = User.allstorysubscribers.count
      @straysubscribercount = User.straysubscribers.count
      @readercount = User.readers.count
      @guestcount = User.guests.count
      @deletedcount = User.deleted.count
      update_all_update_tokens
      end
    else
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    end
  end
  
  def update_all_update_tokens
    @users = User.all
    @users.each do |u|
      u.update(
      update_token: SecureRandom.urlsafe_base64.to_s
      )
    end
  end
  
  def all_off
    u = User.find_by_update_token(params[:id])
    Notification.all.where(user_id: u.id, notificationtype_id: [1, 2]).each do |n|
     n.update(
     notificationtype_id: 3
     )
    end
    flash[:success] = "All switched off."
    redirect_to root_url
  end
  
  def show
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
      @stories = Story.all.order(:story)
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
      @stories = Story.all.order(:story)
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
  
  def edit
    if !User.find_by_id(params[:id])
      if current_user.nil?
        redirect_to root_url
      else
        redirect_to edit_user_path(current_user)
      end
    elsif current_user.nil?
      redirect_to root_url
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
      if @user.stripe_customer_id == "NON-AUTOMATIC INVOICE"
      elsif @user.stripe_customer_id? && @user.role == "reader"
      elsif @user.stripe_customer_id? && @user.role == "subscriber"
      else
      end
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:order)
    elsif current_user != User.find(params[:id])
      redirect_to edit_user_path(current_user)
    elsif current_user = User.find(params[:id])
      @user = current_user
      if @user.stripe_customer_id == "NON-AUTOMATIC INVOICE"
      elsif @user.stripe_customer_id?
        @stripe_customer_details = Stripe::Customer.retrieve(:id => @user.stripe_customer_id)
        @stripe_invoices = Stripe::Invoice.all(:customer => @user.stripe_customer_id)
      else
      end
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:order)
    else
    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
    if current_user.nil? 
      if @user.save
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
    if !User.find_by_id(params[:id])
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    elsif current_user.nil? 
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    elsif current_user.role == 'editor'
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:order)
      @user = User.find(params[:id])
      if @user.stripe_customer_id == "NON-AUTOMATIC INVOICE"
      elsif @user.stripe_customer_id? && @user.role == "reader"
      elsif @user.stripe_customer_id? && @user.role == "subscriber"
        @stripe_customer_details = Stripe::Customer.retrieve(:id => @user.stripe_customer_id)
        @stripe_invoices = Stripe::Invoice.all(:customer => @user.stripe_customer_id)
      else
      end
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to :back}
          format.json { render :edit, status: :ok, location: @user }
          flash[:success] = "Well done, update successful."
        else
          format.html { redirect_to :back }
          format.json { render json: @user.errors, status: :unprocessable_entity }
          flash[:error] = "Oh, problem with update…"
        end
      end
    elsif current_user != User.find(params[:id])
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    else
      @user = current_user
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:order)
      if @user.stripe_customer_id == "NON-AUTOMATIC INVOICE"
      elsif @user.stripe_customer_id?
        @stripe_customer_details = Stripe::Customer.retrieve(:id => @user.stripe_customer_id)
        @stripe_invoices = Stripe::Invoice.all(:customer => @user.stripe_customer_id)
      else
      end
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to :back}
          format.json { render :edit, status: :ok, location: @user }
          flash[:notice] = "Well done, updates successful!"
        else
          format.html { redirect_to :back}
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
      flash[:success] = "You're not allowed to do that."
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'User destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
      flash[:success] = "You're not allowed to do that."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:access_date, :allow_access, :becomes_customer_date, :briefing_frequency, :created_at, :credit_card_id, :credit_card_brand, :credit_card_country, :credit_card_last4, :credit_card_expiry_month, :credit_card_expiry_year, :email, :id, :is_author, :name, :bio, :role, :twitter, :sign_up_url, :password, :password_confirmation, :reset_token, :stripe_customer_id, :one_story_id, :one_story_date, :update_token, :article_ids => [], :story_ids => [], notifications_attributes: [:id, :user_id, :story_id, :notificationtype_id])
    end

end
