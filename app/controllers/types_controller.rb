class TypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  # GET /types
  # GET /types.json
  def index
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @types = Type.all.order ('types.name ASC')
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
 end

  # GET /types/1
  # GET /types/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @tickerstories = Story.bignews.latest.ticker
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /types/new
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @type = Type.new
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /types/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # POST /types
  # POST /types.json
  def create
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @type = Type.new(type_params)
      respond_to do |format|
        if @type.save
          format.html { redirect_to @type, notice: 'Type was successfully created.' }
          format.json { render :show, status: :created, location: @type }
        else
          format.html { render :new }
          format.json { render json: @type.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # PATCH/PUT /types/1
  # PATCH/PUT /types/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @type.update(type_params)
          format.html { redirect_to @type, notice: 'Type was successfully updated.' }
          format.json { render :show, status: :ok, location: @type }
        else
          format.html { render :edit }
          format.json { render json: @type.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # DELETE /types/1
  # DELETE /types/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @type.destroy
      respond_to do |format|
        format.html { redirect_to types_url, notice: 'Type was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @type = Type.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_params
      params.require(:type).permit(:name)
    end
end
