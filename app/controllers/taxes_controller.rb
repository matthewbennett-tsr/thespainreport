class TaxesController < ApplicationController
  before_action :set_tax, only: [:show, :edit, :update, :destroy]

  # GET /taxes
  # GET /taxes.json
  def index
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @taxes = Tax.all
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # GET /taxes/1
  # GET /taxes/1.json
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

  # GET /taxes/new
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @tax = Tax.new
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # GET /taxes/1/edit
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

  # POST /taxes
  # POST /taxes.json
  def create
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @tax = Tax.new(tax_params)
      respond_to do |format|
      if @tax.save
        format.html { redirect_to @tax, notice: 'Tax was successfully created.' }
        format.json { render :show, status: :created, location: @tax }
      else
        format.html { render :new }
        format.json { render json: @tax.errors, status: :unprocessable_entity }
      end
      end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # PATCH/PUT /taxes/1
  # PATCH/PUT /taxes/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      respond_to do |format|
      if @tax.update(tax_params)
        format.html { redirect_to @tax, notice: 'Tax was successfully updated.' }
        format.json { render :show, status: :ok, location: @tax }
      else
        format.html { render :edit }
        format.json { render json: @tax.errors, status: :unprocessable_entity }
      end
    end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # DELETE /taxes/1
  # DELETE /taxes/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @tax.destroy
    respond_to do |format|
      format.html { redirect_to taxes_url, notice: 'Tax was successfully destroyed.' }
      format.json { head :no_content }
    end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      @tax = Tax.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tax_params
      params.require(:tax).permit(:tax_country_name, :tax_country_code, :tax_country_percent)
    end
end