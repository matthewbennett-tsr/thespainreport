class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update, :destroy]

  # GET /histories
  # GET /histories.json
  def index
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @histories = History.all
    else
    end
  end

  # GET /histories/1
  # GET /histories/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
    end
  end
  
  # GET /histories/new
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @history = History.new
    else
    end
  end

  # GET /histories/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
    else
    end
  end

  # POST /histories
  # POST /histories.json
  def create
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @history = History.new(history_params)
      respond_to do |format|
        if @history.save
          format.html { redirect_to @history, notice: 'History was successfully created.' }
          format.json { render :show, status: :created, location: @history }
        else
          format.html { render :new }
          format.json { render json: @history.errors, status: :unprocessable_entity }
        end
      end
    else
    end
  end

  # PATCH/PUT /histories/1
  # PATCH/PUT /histories/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @history.update(history_params)
          format.html { redirect_to @history, notice: 'History was successfully updated.' }
          format.json { render :show, status: :ok, location: @history }
        else
          format.html { render :edit }
          format.json { render json: @history.errors, status: :unprocessable_entity }
        end
      end
    else
    end
  end

  # DELETE /histories/1
  # DELETE /histories/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @history.destroy
      respond_to do |format|
        format.html { redirect_to histories_url, notice: 'History was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def history_params
      params.require(:history).permit(:user_id, :article_id, :read_date)
    end
end
