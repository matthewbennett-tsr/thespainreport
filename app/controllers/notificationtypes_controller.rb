class NotificationtypesController < ApplicationController
  before_action :set_notificationtype, only: [:show, :edit, :update, :destroy]

  # GET /notificationtypes
  # GET /notificationtypes.json
  def index
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @notificationtypes = Notificationtype.all
    else
      redirect_to root_url
    end
  end

  # GET /notificationtypes/1
  # GET /notificationtypes/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
      redirect_to root_url
    end
  end

  # GET /notificationtypes/new
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @notificationtype = Notificationtype.new
    else
      redirect_to root_url
    end
  end

  # GET /notificationtypes/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
      redirect_to root_url
    end
  end

  # POST /notificationtypes
  # POST /notificationtypes.json
  def create
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @notificationtype = Notificationtype.new(notificationtype_params)
      respond_to do |format|
        if @notificationtype.save
          format.html { redirect_to @notificationtype }
          format.json { render :show, status: :created, location: @notificationtype }
          flash[:success] = "Notification type created." 
        else
          format.html { render :new }
          format.json { render json: @notificationtype.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end  
  end

  # PATCH/PUT /notificationtypes/1
  # PATCH/PUT /notificationtypes/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @notificationtype.update(notificationtype_params)
          format.html { redirect_to :back }
          format.json { render :show, status: :ok, location: @notificationtype }
          flash[:success] = "Notification type updated."
        else
          format.html { render :edit }
          format.json { render json: @notificationtype.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end 
  end

  # DELETE /notificationtypes/1
  # DELETE /notificationtypes/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @notificationtype.destroy
      respond_to do |format|
        format.html { redirect_to notificationtypes_url}
        format.json { head :no_content }
        flash[:success] = "Notification type deleted."
      end
    else
      redirect_to root_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notificationtype
      @notificationtype = Notificationtype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notificationtype_params
      params.require(:notificationtype).permit(:name, :order)
    end
end
