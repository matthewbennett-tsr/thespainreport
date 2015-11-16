class SalesemailsController < ApplicationController
  before_action :set_salesemail, only: [:show, :edit, :update, :destroy]

  # GET /salesemails
  # GET /salesemails.json
  def index
    @salesemails = Salesemail.all
    @salesemails_readers = Salesemail.readers.order( 'salesemails.send_order ASC' )
    @salesemails_subscribers = Salesemail.subscribers
  end

  # GET /salesemails/1
  # GET /salesemails/1.json
  def show
  end

  # GET /salesemails/new
  def new
    @salesemail = Salesemail.new
  end

  # GET /salesemails/1/edit
  def edit
  end

  # POST /salesemails
  # POST /salesemails.json
  def create
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
  end

  # PATCH/PUT /salesemails/1
  # PATCH/PUT /salesemails/1.json
  def update
    respond_to do |format|
      if @salesemail.update(salesemail_params)
        format.html { redirect_to @salesemail, notice: 'Salesemail was successfully updated.' }
        format.json { render :show, status: :ok, location: @salesemail }
      else
        format.html { render :edit }
        format.json { render json: @salesemail.errors, status: :unprocessable_entity }
      end
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
