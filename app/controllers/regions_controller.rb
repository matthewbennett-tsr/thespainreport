class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy]

  def tickerstories
    @tickerstories = Article.bignews.published.latest.ticker
  end
  
  # GET /regions
  # GET /regions.json
  def index
    @regions = Region.all.order( 'regions.region ASC' )
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
    @last50items = Newsitem.published.lastfifty
  end

  # GET /regions/new
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @region = Region.new
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /regions/1/edit
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

  # POST /regions
  # POST /regions.json
  def create
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @region = Region.new(region_params)
      respond_to do |format|
        if @region.save
          format.html { redirect_to @region, notice: 'Region was successfully created.' }
          format.json { render :show, status: :created, location: @region }
        else
          format.html { render :new }
          format.json { render json: @region.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # PATCH/PUT /regions/1
  # PATCH/PUT /regions/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @region.update(region_params)
          format.html { redirect_to @region, notice: 'Region was successfully updated.' }
          format.json { render :show, status: :ok, location: @region }
        else
          format.html { render :edit }
          format.json { render json: @region.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @region.destroy
      respond_to do |format|
        format.html { redirect_to regions_url, notice: 'Region was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @region = Region.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def region_params
      params.require(:region).permit(:description, :region, :keywords, :article_ids => [], :newsitem_ids => [])
    end
end
