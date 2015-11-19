class SalesemailsController < ApplicationController
  before_action :set_salesemail, only: [:show, :edit, :update, :destroy]

  # GET /salesemails
  # GET /salesemails.json
  def index
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @salesemails = Salesemail.all
      @salesemails_readers = Salesemail.readers.order( 'salesemails.send_order ASC' )
      @salesemails_subscribers = Salesemail.subscribers
    else
    end
  end

  # GET /salesemails/1
  # GET /salesemails/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
    else
    end
  end

  # GET /salesemails/new
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @salesemail = Salesemail.new
    else
    end
  end

  # GET /salesemails/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
    else
    end
  end

  # POST /salesemails
  # POST /salesemails.json
  def create
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @salesemail = Salesemail.new(salesemail_params)
      respond_to do |format|
        if @salesemail.save
          format.html { redirect_to @salesemail, notice: 'Salesemail was successfully created.' }
          format.json { render :show, status: :created, location: @salesemail }
        else
          format.html { render :new }
          format.json { render json: @salesemail.errors, status: :unprocessable_entity }
        end
      end
    else
    end
  end

  # PATCH/PUT /salesemails/1
  # PATCH/PUT /salesemails/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @salesemail.update(salesemail_params)
          format.html { redirect_to @salesemail, notice: 'Salesemail was successfully updated.' }
          format.json { render :show, status: :ok, location: @salesemail }
        else
          format.html { render :edit }
          format.json { render json: @salesemail.errors, status: :unprocessable_entity }
        end
      end
    else
    end
  end

  # DELETE /salesemails/1
  # DELETE /salesemails/1.json
  def destroy
    @salesemail.destroy
    respond_to do |format|
      format.html { redirect_to salesemails_url, notice: 'Salesemail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_salesemail
      @salesemail = Salesemail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def salesemail_params
      params.require(:salesemail).permit(:to, :send_order, :delay_number, :delay_period, :subject, :message)
    end
end
