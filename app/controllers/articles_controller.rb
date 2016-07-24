class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.published.lastthirty
  end
  
  # GET /articles/admin
  # GET /articles/admin.json
  def admin
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @articles = Article.all.order( 'articles.created_at DESC' )
      @articleslastfewdays = Article.lastfewdays.order( 'articles.created_at DESC' )
      @articleslast24 = Article.last24.order( 'articles.created_at DESC' )
      @articlesnext24 = Article.next24.order( 'articles.created_at DESC' )
      @articlesfollowing5days = Article.following5days.order( 'articles.created_at DESC' )
      @articlesfollowing614days = Article.following614days.order( 'articles.created_at DESC' )
      @articlesupto30days = Article.upto30days.order( 'articles.created_at DESC' )
      @newscount = Article.news.count
      @editorialcount = Article.editorial.count
      @indepthcount = Article.in_depth.count
      @blogcount = Article.is_blog.count
      @bignews = Article.bignews.order('updated_at DESC')
      @articlesbymonth = Article.all.order('created_at DESC').group_by { |t| t.created_at.beginning_of_month }
      @articlesbyweek = Article.all.order('created_at DESC').group_by { |t| t.created_at.beginning_of_week }
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end
  
  # GET /articles/blog
  # GET /articles/blog.json
  def blog
    @is_blog = Article.is_blog.published.lastthirty.order( 'articles.updated_at DESC' )
    @latestupdates = Newsitem.published.lastten
    @lasteditorial = Article.editorial.published.lastone
    @lastindepth = Article.in_depth.published.lastone
  end
  
  # GET /articles/in-depth
  # GET /articles/in-depth.json
  def in_depth
    @last30 = Article.in_depth.published.lastthirty
  end
  
  # GET /articles/news
  # GET /articles/news.json
  def news
    @last30 = Article.news.bignews.published.lastthirty
  end
  
  # GET /articles/editorial
  # GET /articles/editorial.json
  def editorial
    @last30 = Article.editorial.published.lastthirty
  end
  
  # GET /articles/1
  # GET /articles/1.json
  def show
    @region = Article.find(params[:id])
    @category = Article.find(params[:id])
    @story = Article.find(params[:id])
    @type = Article.find(params[:id])
    @latestaudio = Audio.lastone
    @title = "some custom page title"
    @articleupdates = @article.newsitems.published
    @comments = @article.comments
    @last30items = Newsitem.published.lastthirty
    @last6articles = Article.published.lastsix
  end
   
  # GET /articles/new
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @article = Article.new
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
      @types = Type.all.order(:name)
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # GET /articles/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
      @types = Type.all.order(:name)
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end  
  end

  def articleurgency
    if @article.short_slug?
      @article.short_slug + ': '
    elsif @article.urgency == 'majorbreaking'
      "MAJOR BREAKING: "
    elsif @article.urgency == 'breaking'
      "BREAKING: "
    elsif @article.urgency == 'latest'
      "LATEST: "
    else
      "#{@article.type.name}: "
    end
  end

  def twitter
    if @article.main? && params[:tweet] == '1'
      $client.update_with_media(tweet, open(tweetimage))
    elsif params[:tweet] == '1'
      $client.update(tweet)
    else
    end
  end

  def tweet
    if @article.video?
      articleurgency + updatetext + ' ' + updatelink + ' ' + tweetvideo
    else
      articleurgency + updatetext + ' ' + updatelink
    end
  end
  
  def updatetext
    if @article.short_headline?
      @article.short_headline
    else
      @article.headline
    end
  end

  def updatelink
    article_url(@article)
  end
  
  def updatelinktest
    'https://www.thespainreport.com/'
  end
  
  def tweetimage
    @article.main.url
  end

  def tweetvideo
   'https://www.youtube.com/watch?v=' + @article.video
  end
  
  def emailsummaries
    if @article.email_to == 'none'
    
    elsif @article.email_to == 'all'
      User.wantssummariesbreaking.editors.each do |user|
        ArticleMailer.delay.send_article_full(@article, user)
	  end
	  User.wantssummariesbreaking.subscribers.each do |user|
        ArticleMailer.delay.send_article_full(@article, user)
	  end
	  User.wantssummariesbreaking.readers.each do |user|
        ArticleMailer.delay.send_article_teaser(@article, user)
	  end
    elsif @article.email_to == 'readers'
      User.wantssummariesbreaking.readers.each do |user|
        ArticleMailer.delay.send_article_full(@article, user)
	  end
    elsif @article.email_to == 'subscribers'
      User.subscribers.wantssummariesbreaking.each do |user|
        ArticleMailer.delay.send_article_full(@article, user)
	  end
    else
    end
  end
  
  def emailarticles
    if @article.email_to == 'none'
    
    elsif @article.email_to == 'all'
      if @article.type.name == 'BLOG'
        User.all.each do |user|
          ArticleMailer.delay.send_article_full(@article, user)
	    end
      else
        User.wantsarticles.editors.each do |user|
          ArticleMailer.delay.send_article_full(@article, user)
        end
	    User.wantsarticles.subscribers.each do |user|
          ArticleMailer.delay.send_article_full(@article, user)
	    end
	    User.wantsarticles.readers.each do |user|
          ArticleMailer.delay.send_article_teaser(@article, user)
	    end
      end
    elsif @article.email_to == 'readers'
      if @article.type.name == 'BLOG'
        User.readers.each do |user|
          ArticleMailer.delay.send_article_full(@article, user)
	    end
      else
        User.wantsarticles.readers.each do |user|
          ArticleMailer.delay.send_article_full(@article, user)
	    end
	  end
    elsif @article.email_to == 'subscribers'
      if @article.type.name == 'BLOG'
        User.subscribers.each do |user|
          ArticleMailer.delay.send_article_full(@article, user)
	    end
      else
        User.subscribers.wantsarticles.each do |user|
          ArticleMailer.delay.send_article_full(@article, user)
	    end
	  end
    else
    end
  end

  def new_summary
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @article = Article.new
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
      @types = Type.all.order(:name)
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # POST /articles
  # POST /articles.json
  def create
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @article = Article.new(article_params)
      respond_to do |format|
        if @article.save && ["draft", "editing"].include?(@article.status)
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        elsif @article.save && ["published", "updated"].include?(@article.status) && ["SUMMARY"].include?(@article.type.name) || @article.save && ["published", "updated"].include?(@article.status) && ["breaking", "majorbreaking"].include?(@article.urgency)
          emailsummaries
		  twitter
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        elsif @article.save && ["published", "updated"].include?(@article.status)
          emailarticles
          twitter
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { redirect_to edit_article_path(@article) }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end  
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @article.update(article_params) && ["draft", "editing"].include?(@article.status)
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully updated.' }
          format.json { render :show, status: :created, location: @article }
        elsif @article.update(article_params) && ["published", "updated"].include?(@article.status) && ["SUMMARY"].include?(@article.type.name) || @article.update(article_params) && ["published", "updated"].include?(@article.status) && ["breaking", "majorbreaking"].include?(@article.urgency)
          emailsummaries
		  twitter
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully udpated.' }
          format.json { render :show, status: :created, location: @article }
        elsif @article.update(article_params) && ["published", "updated"].include?(@article.status)
          emailarticles
          twitter
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully updated.' }
          format.json { render :show, status: :ok, location: @article }
        else
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully updated.' }
          format.json { render :show, status: :ok, location: @article }
        end
      end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    elsif current_user.role == 'editor'
      @article.destroy
      respond_to do |format|
        format.html { redirect_to :action => 'admin', notice: 'Article was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_url
      flash[:success] = message_error_not_allowed
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:body, :caption, :created_at, :email_to, :headline, :lede, :main, :remove_main, :short_slug, :short_headline, :status, :source, :topstory, :type_id, :updated_at, :urgency, :video, :summary, :summary_slug, :category_ids => [], :region_ids => [], :story_ids => [])
    end
end
