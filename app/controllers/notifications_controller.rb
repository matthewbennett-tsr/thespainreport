class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]

  # GET /notifications
  # GET /notifications.json
  def index
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @notifications = Notification.all
    else
      redirect_to root_url
    end
  end

  def emergency_regenerate_notifications
    User.deleted.each do |u|
      u.notifications.each do |n|
        n.delete
      end
    end
    
    User.notdeleted.each do |u|
     Story.all.each do |s|
       Notification.where(user_id: u.id, story_id: s.id).first_or_create(notificationtype_id: 1)
     end
    end
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
      redirect_to root_url
    end
  end

  # GET /notifications/new
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @notification = Notification.new
      @notificationtypes = Notificationtype.all.order(:name)
      @stories = Story.all.order(:story)
    else
      redirect_to root_url
    end
  end

  # GET /notifications/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @stories = Story.all.order(:story)
      @notificationtypes = Notificationtype.all.order(:name)
    else
      redirect_to root_url
    end
  end
  
  def update_all_notification_tokens
    @notifications = Notification.all
    @notifications.each do |n|
      n.check_update_token
    end
  end
  
  def update_type
    n = Notification.find_by_update_token(params[:id])
    n.update(notificationtype_id: params[:type])
    flash[:success] = "Update successful."
    redirect_to root_url
  end

  # POST /notifications
  # POST /notifications.json
  def create
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @notification = Notification.new(notification_params)
      respond_to do |format|
        if @notification.save
          format.html { redirect_to @notification, notice: 'Notification created.' }
          format.json { render :show, status: :created, location: @notification }
        else
          format.html { render :new }
          format.json { render json: @notification.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @notification.update(notification_params)
          format.html { redirect_to @notification, notice: 'Notification updated.' }
          format.json { render :show, status: :ok, location: @notification }
        else
          format.html { render :edit }
          format.json { render json: @notification.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:urgency, :notificationtype_id, :story_id, :user_id, :update_token)
    end
end