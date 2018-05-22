class UsersController < ApplicationController

  def index
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      if params[:search]
      terms = params[:search].scan(/"[^"]*"|'[^']*'|[^"'\s]+/)
      query = terms.map { |term| "email ILIKE '%#{term}%' OR role ILIKE '%#{term}%'" }.join(" OR ")
      @users = User.all.where(query).order("created_at DESC")
      @userscount = @users.count
      else
      end
      @totalactivecount = User.notdeleted.count
      @subscribercount = User.subscribers.count
      @onestorycount = User.onestorysubscribers.count
      @allcurrentcount = User.allcurrentsubscribers.count
      @allstorycount = User.allstorysubscribers.count
      @pre2018count = User.pre2018.count
      @pausedcount = User.pausedsubscribers.count
      @cancelledcount = User.cancelledsubscribers.count
      @nostripecount = User.nostripeid.count
      @readercount = User.readers.count
      @guestcount = User.guests.count
      @deletedcount = User.deleted.count
      @subscribers = User.subscribers.lastfew
      @readers = User.readers.lastfew
      @guests = User.guests.lastfew
      @deleted = User.deleted.lastfew
      @dateblank = User.notdeleted.dateblank.count
    else
      redirect_to root_url
    end
  end
  
	def all_subscribers
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 'editor'
			if params[:search]
				terms = params[:search].scan(/"[^"]*"|'[^']*'|[^"'\s]+/)
				query = terms.map { |term| "email ILIKE '%#{term}%'" }.join(" OR ")
				@users = User.all.where(query).order("created_at DESC")
				@latestusers = User.readers.lastfew
				@latestsubscribers = User.totalsubscribers.lastfew
			else
				@subscribers = User.totalsubscribers.lastfew
				@subscribercount = User.totalsubscribers.count
				@onestorysubscribers = User.onestorysubscribers.count
				@allstorysubscribers = User.allstorysubscribers.count
				@straysubscribercount = User.straysubscribers.count
			end
		else
			redirect_to root_url
		end
	end
  
  def update_all_update_tokens
    User.all.each do |u|
      u.check_update_token
    end
  end
  
  def all_to_briefings
    u = User.find_by_update_token(params[:id])
    Notification.all.where(user_id: u.id, notificationtype_id: [1, 3, 4]).each do |n|
     n.update(
     notificationtype_id: 2
     )
    end
    flash[:success] = "All to briefings."
    redirect_to root_url
  end
  
  def all_off
    u = User.find_by_update_token(params[:id])
    
    u.update(
    briefing_frequency_id: 8
    )
    
    Notification.all.where(user_id: u.id, notificationtype_id: [1, 2, 4]).each do |n|
     n.update(
     notificationtype_id: 3
     )
    end
    flash[:success] = "All switched off."
    redirect_to root_url
  end
  
  def update_freq
    u = User.find_by_update_token(params[:id])
    u.update(briefing_frequency_id: params[:freq])
    flash[:success] = "Update successful."
    redirect_to root_url
  end
  
  def show
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
      @stories = Story.all.order(:story)
    else
      redirect_to root_url
    end
  end
  
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @user = User.new
      @stories = Story.all.order(:story)
    else
      redirect_to root_url
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
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:order)
      @briefingfrequencies = BriefingFrequency.all.order(:id)
    elsif current_user != User.find(params[:id])
      redirect_to edit_user_path(current_user)
    elsif current_user = User.find(params[:id])
      @user = current_user
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:order)
      @briefingfrequencies = BriefingFrequency.all.order(:id)
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
    elsif current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:order)
      @user = User.find(params[:id])
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
    else
      @user = current_user
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:order)
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to :back}
          format.json { render :edit, status: :ok, location: @user }
          flash[:success] = "Well done, updates successful!"
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
    elsif current_user.role == 'editor'
      @user = User.find(params[:id])
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'User destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
      :access_date,
      :account_id,
      :account_subscription_id,
      :account_role,
      :allow_access,
      :becomes_customer_date,
      :becomes_customer_date_spain,
      :briefing_frequency_id,
      :created_at,
      :credit_card_id,
      :credit_card_brand,
      :credit_card_country,
      :credit_card_last4,
      :credit_card_expiry_month,
      :credit_card_expiry_year,
      :credit_card_id_spain,
      :credit_card_brand_spain,
      :credit_card_country_spain,
      :credit_card_last4_spain,
      :credit_card_expiry_month_spain,
      :credit_card_expiry_year_spain,
      :email, :id, :is_author, :name, :bio, :role, :twitter, :sign_up_url, :password, :password_confirmation, :reset_token, :stripe_customer_id, :stripe_customer_id_spain, :one_story_id, :one_story_date, :update_token, :article_ids => [], :story_ids => [], notifications_attributes: [:id, :user_id, :story_id, :notificationtype_id])
    end

end
