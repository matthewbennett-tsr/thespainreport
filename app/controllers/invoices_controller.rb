class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @invoices = Invoice.all
    else
      redirect_to root_url
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      
    else
      redirect_to root_url
    end
  end

  # GET /invoices/new
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @invoice = Invoice.new
    else
      redirect_to root_url
    end
  end

  # GET /invoices/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.id == @invoice.user.id
     
    elsif current_user.role == 'editor'
      
    else
      redirect_to root_url
    end
  end

  # POST /invoices
  # POST /invoices.json
  def create
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @invoice = Invoice.new(invoice_params)
      respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
      end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end  
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor' || current_user.id == @invoice.user.id
      respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to edit_invoice_path, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
      end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @invoice.destroy
      respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
      end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(
        :invoice_for,
        :invoice_for_date,
        :stripe_invoice_id,
        :user_id,
        :subscription_id,
        :stripe_invoice_currency,
        :stripe_invoice_interval,
        :stripe_invoice_number,
        :stripe_invoice_date,
        :stripe_invoice_item,
        :stripe_invoice_quantity,
        :stripe_invoice_price,
        :stripe_invoice_subtotal,
        :stripe_invoice_credit_card_country,
        :stripe_invoice_ip_country_code,
        :stripe_invoice_ip_country_code_2,
        :stripe_invoice_tax_percent,
        :stripe_invoice_tax_amount,
        :stripe_invoice_total,
        :paid,
        :status,
        :number
        )
    end
end
