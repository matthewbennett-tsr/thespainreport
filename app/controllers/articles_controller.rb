class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.published.lastthirty
    @tickerstories = Story.bignews.latest.ticker
  end
  
  # GET /articles/admin
  # GET /articles/admin.json
  def admin
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @articles = Article.all.order( 'articles.updated_at DESC' )
      @articlestoday = Article.today.order( 'articles.created_at DESC' )
      @articlestomorrow = Article.tomorrow.order( 'articles.created_at DESC' )
      @articlesrestofweek = Article.restofweek.order( 'articles.created_at DESC' )
      @articlesweekafter = Article.weekafter.order( 'articles.created_at DESC' )
      @articlesrestofmonth = Article.restofmonth.order( 'articles.created_at DESC' )
      @newscount = Article.news.count
      @editorialcount = Article.editorial.count
      @indepthcount = Article.in_depth.count
      @blogcount = Article.is_blog.count
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end
  
  # GET /articles/blog
  # GET /articles/blog.json
  def blog
    @is_blog = Article.is_blog.published.lastthirty.order( 'articles.updated_at DESC' )
    @tickerstories = Story.bignews.latest.ticker
  end
  
  # GET /articles/in-depth
  # GET /articles/in-depth.json
  def in_depth
    @last30 = Article.in_depth.published.lastthirty
    @tickerstories = Story.bignews.latest.ticker
  end
  
  # GET /articles/news
  # GET /articles/news.json
  def news
    @last30 = Article.news.published.lastthirty
    @tickerstories = Story.bignews.latest.ticker
  end
  
  # GET /articles/editorial
  # GET /articles/editorial.json
  def editorial
    @last30 = Article.editorial.published.lastthirty
    @tickerstories = Story.bignews.latest.ticker
  end
  
  # GET /articles/1
  # GET /articles/1.json
  def show
    @region = Article.find(params[:id])
    @category = Article.find(params[:id])
    @story = Article.find(params[:id])
    @type = Article.find(params[:id])
    @tickerstories = Story.bignews.latest.ticker
    @latestaudio = Audio.lastone
    @title = "some custom page title"
    @articleupdates = @article.newsitems
    @comments = @article.comments
  end

  # GET /articles/new
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @article = Article.new
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
      @types = Type.all.order(:name)
      
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /articles/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
      @types = Type.all.order(:name)
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end  
  end

  # POST /articles
  # POST /articles.json
  def create
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @article = Article.new(article_params)
      respond_to do |format|
        if @article.save && @article.status == 'published' && @article.created_at.today?
          User.wantsarticles.editors.each do |user|
            ArticleMailer.delay.send_article_full(@article, user)
		  end
		  User.wantsarticles.subscribers.each do |user|
            ArticleMailer.delay.send_article_full(@article, user)
		  end
		  User.wantsarticles.readers.each do |user|
            ArticleMailer.delay.send_article_teaser(@article, user)
		  end
          format.html { redirect_to :action => 'admin', notice: 'Article was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        elsif @article.save
          format.html { redirect_to :action => 'admin', notice: 'Article was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { render :new }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end  
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @article.update(article_params) && @article.status == 'published' && @article.created_at.today?
          User.wantsarticles.editors.each do |user|
            ArticleMailer.delay.send_article_full(@article, user)
		  end
		  User.wantsarticles.subscribers.each do |user|
            ArticleMailer.delay.send_article_full(@article, user)
		  end
		  User.wantsarticles.readers.each do |user|
            ArticleMailer.delay.send_article_teaser(@article, user)
		  end
          format.html { redirect_to :action => 'admin', notice: 'Article was successfully updated.' }
          format.json { render :show, status: :ok, location: @article }
        else
          format.html { redirect_to :action => 'admin', notice: 'Article was successfully updated.' }
          format.json { render :show, status: :ok, location: @article }
        end
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @article.destroy
      respond_to do |format|
        format.html { redirect_to :action => 'admin', notice: 'Article was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:body, :caption, :created_at, :headline, :lede, :main, :remove_main, :status, :source, :type_id, :updated_at, :urgency, :video, :category_ids => [], :region_ids => [], :story_ids => [])
    end
end
