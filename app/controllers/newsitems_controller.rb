class NewsitemsController < ApplicationController
  before_action :set_newsitem, only: [:show, :edit, :update, :destroy]

  # GET /newsitems
  # GET /newsitems.json
  def index
    @last30items = Newsitem.published.lastthirty
    @last50items = Newsitem.published.lastfifty
    @tickerstories = Story.bignews.latest.ticker
    @user = User.new
  end
  
  # GET /newsitems/admin
  # GET /newsitems/admin.json
  def admin
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @newsitems = Newsitem.all.order( 'newsitems.updated_at DESC' )
      @updatecount = Newsitem.count
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /newsitems/1
  # GET /newsitems/1.json
  def show
    @region = Newsitem.find(params[:id])
    @category = Newsitem.find(params[:id])
    @story = Newsitem.find(params[:id])
    @tickerstories = Story.bignews.latest.ticker
    @latestaudio = Audio.lastone
    @comments = @newsitem.comments
    @user = User.new
  end

  # GET /newsitems/new
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @newsitemarticle = Article.published.lastthirty
      @newsitem = Newsitem.new
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /newsitems/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @newsitemarticle = Article.published.lastthirty
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end 	
  end

  # POST /newsitems
  # POST /newsitems.json
  def create
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @newsitem = Newsitem.new(newsitem_params)
      respond_to do |format|
        if @newsitem.save && @newsitem.status == 'published' && @newsitem.created_at.today?
          User.wantsupdates.each do |user|
            NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
		  end
          format.html { redirect_to :action => 'admin', notice: 'Update was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        elsif @newsitem.save
          format.html { redirect_to :action => 'admin', notice: 'Update was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { render :new }
          format.json { render json: @newsitem.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # PATCH/PUT /newsitems/1
  # PATCH/PUT /newsitems/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @newsitem.update(newsitem_params) && @newsitem.status == 'published' && @newsitem.created_at.today?
          User.wantsupdates.each do |user|
            NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
		  end
          format.html { redirect_to :action => 'admin', notice: 'Newsitem was successfully updated.' }
          format.json { render :show, status: :ok, location: @newsitem }
        elsif @newsitem.update
          format.html { redirect_to :action => 'admin', notice: 'Update was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { render :edit }
          format.json { render json: @newsitem.errors, status: :unprocessable_entity }
        end
      end  
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # DELETE /newsitems/1
  # DELETE /newsitems/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @newsitem.destroy
      respond_to do |format|
        format.html { redirect_to :action => 'admin', notice: 'Newsitem was successfully destroyed.' }
        format.json { head :no_content }
      end   
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_newsitem
      @newsitem = Newsitem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def newsitem_params
      params.require(:newsitem).permit(:article_id, :caption, :created_at, :imagesource, :item, :main, :source, :status, :updated_at, :remove_main, :slug, :url, :video, :region_ids => [], :category_ids => [], :story_ids => [])
    end
end
