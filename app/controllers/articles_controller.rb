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
    end
  end
  
# Start briefings logic for cron
  # Sundays 10 a.m. briefing: create web briefing, send e-mail briefings
  def create_sunday_am_web_briefing
    if Article.last48.notbriefing.published.present?
      a = Article.new
      a.type_id = 32
      a.status = 'published'
      a.headline = 'Spain Briefing: ' + Time.now.strftime("%A, %b %-d, %Y at %l:%M %p")
      a.short_headline = 'Spain Briefing: ' + Time.now.strftime("%d/%m/%y, %l:%M %p")
      a.lede = 'Sign up now to get these briefings in your inbox.'
      a.short_lede = 'Sign up now to get these briefings in your inbox.'
      a.body = web_sunday_am_briefing_article_text
      a.save!
    else
    end
  end
  
  def web_sunday_am_briefing_article_text
    arr = Array.new
    Article.last48.notbriefing.published.each do |a|
    arr << "**" + a.short_headline.to_s + "**: " + a.briefing_point.to_s + " ([Read now](/articles/#{a.id}-#{a.created_at.strftime("%y%m%d%H%M%S")}-#{a.headline.parameterize}))"
    end
    arr.join("\n\n")
  end
  
  def briefing_sunday_10_am
    User.notdeleted.each do |user|
      userid = user.id
      if [12].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_48(userid)
      elsif [84].include?(user.briefing_frequency.briefing_frequency)
        
      elsif [168].include?(user.briefing_frequency.briefing_frequency)
        
      else
      end
    end
  end

  # Weekday 10 a.m. briefing: create 24-hour web briefing, send e-mail briefings
  def create_am_web_briefing
    if Article.last24.notbriefing.published.present?
      a = Article.new
      a.type_id = 32
      a.status = 'published'
      a.headline = 'Spain Briefing: ' + Time.now.strftime("%A, %b %-d, %Y at %l:%M %p")
      a.short_headline = 'Spain Briefing: ' + Time.now.strftime("%d/%m/%y, %l:%M %p")
      a.lede = 'Sign up now to get these briefings in your inbox.'
      a.short_lede = 'Sign up now to get these briefings in your inbox.'
      a.body = web_am_briefing_article_text
      a.save!
    else
    end
  end
  
  def web_am_briefing_article_text
    arr = Array.new
    Article.last24.notbriefing.published.each do |a|
    arr << "**" + a.short_headline.to_s + "**: " + a.briefing_point.to_s + " ([Read now](/articles/#{a.id}-#{a.created_at.strftime("%y%m%d%H%M%S")}-#{a.headline.parameterize}))"
    end
    arr.join("\n\n")
  end
  
  def briefing_monday_to_friday_10_am
    User.notdeleted.each do |user|
      userid = user.id
      if [2,3,6,12].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_12(userid)
      elsif [24].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_24(userid)
      else
      end
    end
  end
  
  # Weekday X-hourly briefings, every 2, every 3, and 4 p.m. for 2,3,6
  def briefing_every_2_hours
    User.notdeleted.each do |user|
      userid = user.id
      if [2].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_2(userid)
      else
      end
    end
  end
  
  def briefing_every_3_hours
    User.notdeleted.each do |user|
      userid = user.id
      if [3].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_3(userid)
      else
      end
    end
  end
  
  def briefing_monday_to_friday_4_pm
    User.notdeleted.each do |user|
      userid = user.id
      if [2].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_2(userid)
      elsif [3].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_3(userid)
      elsif [6].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_6(userid)
      else
      end
    end
  end  
  
  # Weekday 10 p.m. briefing: create 12-hour 10 p.m. briefing, send e-mail briefings, on Wednesday nights send twice weekly e-mail briefing
  def create_pm_web_briefing
    if Article.last12.notbriefing.published.present?
      a = Article.new
      a.type_id = 32
      a.status = 'published'
      a.headline = 'Spain Briefing: ' + Time.now.strftime("%A, %b %-d, %Y at %l:%M %p")
      a.short_headline = 'Spain Briefing: ' + Time.now.strftime("%d/%m/%y, %l:%M %p")
      a.lede = 'Sign up now to get these briefings in your inbox.'
      a.short_lede = 'Sign up now to get these briefings in your inbox.'
      a.body = web_pm_briefing_article_text
      a.save!
    else
    end
  end
  
  def web_pm_briefing_article_text
    arr = Array.new
    Article.last12.notbriefing.published.each do |a|
      arr << "**" + a.short_headline.to_s + "**: " + a.briefing_point.to_s + " ([Read now](/articles/#{a.id}-#{a.created_at.strftime("%y%m%d%H%M%S")}-#{a.headline.parameterize}))"
    end
    arr.join("\n\n")
  end
  
  def briefing_monday_to_friday_10_pm
    User.notdeleted.each do |user|
      userid = user.id
      if [2].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_2(userid)
      elsif [3].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_3(userid)
      elsif [6].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_6(userid)
      elsif [12].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_12(userid)
      else
      end
    end
  end
  
  def briefing_wednesday_10pm
    User.notdeleted.each do |user|
      userid = user.id
      if [84].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_84(userid)
      else
      end
    end
  end
# Ends briefings logic

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
  
  def show_article_elements
      @article = Article.includes(:type, :newsitems).find(params[:id])
      
      @articleupdates = @article.newsitems.published.order('updated_at ASC')
      @liveblogupdates = @article.newsitems.published.order('updated_at DESC')
      @articletweets = @article.tweets.order('updated_at ASC')
      @notificationtypes = Notificationtype.all.order(:order)
  end
  
  # GET /articles/1
  # GET /articles/1.json
  def show
    if ["published", "updated"].include?@article.status
      show_article_elements
      if current_user.nil?
      
      else
        h = History.where(article_id: @article, user_id: current_user).first
        if h.present?
          h.touch
        else
          h = History.new
          h.article_id = @article.id
          h.user_id = current_user.id
          h.save!
        end
      end
    elsif current_user.nil? || current_user.role != 'editor'
      redirect_to root_url
      flash[:error] = "Article does not exist."
    elsif current_user.role = 'editor'
      show_article_elements
    else
      redirect_to root_url
      flash[:error] = "Article does not exist."
    end
  end
   
  # GET /articles/new
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @article = Article.new
      @stories = Story.all.includes(:category).order(:story)
      @types = Type.all.order(:name)
    else
      redirect_to root_url
    end
  end
  
  # GET /articles/breaking
  def breaking
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @stories = Story.all.order(:story)
      @types = Type.all.order(:name)
      
      @article = Article.new
      @article.type_id = 2
      @article.urgency = 'breaking'
      @article.status = 'published'
      @article.topstory = true
      @article.lede = 'Breaking story…more to follow.'
      @article.body = ''
      @article.short_headline = 'XXXXX'
    else
      redirect_to root_url
    end
  end
  
  # GET /articles/latest
  def latest
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @stories = Story.all.order(:story)
      @types = Type.all.order(:name)
      
      @article = Article.new
      @article.type_id = 2
      @article.urgency = 'latest'
      @article.status = 'published'
      @article.topstory = true
      @article.lede = 'Developing…more to follow.'
      @article.body = ''
      @article.short_headline = 'XXXXX'
    else
      redirect_to root_url
    end
  end

  # GET /articles/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @stories = Story.all.includes(:category).order(:story)
      @types = Type.all.order(:name)
    else
      redirect_to root_url
    end  
  end

  def articleurgency
    if @article.notification_slug?
      @article.notification_slug + ': '
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
    if @article.notification_message?
      @article.notification_message
    else
      @article.headline.present? ? @article.headline : @article.short_headline
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
  
  def emailarticles
		if @article.email_to == 'none'
		
		elsif @article.email_to == 'test'
			User.editors.each do |user|
				ArticleMailer.delay.send_article_full(@article, user)
			end
		elsif @article.email_to == 'all'
			if ["BLOG"].include?(@article.type.try(:name))
				User.notdeleted.each do |user|
					ArticleMailer.delay.send_article_full(@article, user)
				end
			elsif @article.is_free || ["LIVE BLOG", "VIDEO BLOG"].include?(@article.type.try(:name))
				User.notdeleted.each do |user|
					Notification.where(user_id: user.id, story_id: @article.story_ids, notificationtype_id: 1).first(1).each do
						ArticleMailer.delay.send_article_full(@article, user)
					end
				end
			else
				User.notdeleted.each do |user|
				Notification.where(user_id: user.id, story_id: @article.story_ids, notificationtype_id: 1).first(1).each do
					if user.access_date.blank?
						ArticleMailer.delay.send_article_full(@article, user)
					elsif user.access_date < Time.current
						if ['reader', 'guest'].include?(user.role)
							ArticleMailer.delay.send_article_subscribe(@article, user)
						elsif ['subscriber_one_story', 'subscriber_paused', 'subscriber_all_stories', 'subscriber'].include?(user.role)
							ArticleMailer.delay.send_article_resubscribe(@article, user)
						end
					elsif user.access_date >= Time.current
						if user.role == 'subscriber_one_story'
							if @article.story_ids.include?(user.one_story_id)
								ArticleMailer.delay.send_article_full(@article, user)
							elsif @article.story_ids.exclude?(user.one_story_id)
								ArticleMailer.delay.send_article_upgrade(@article, user)
							end
						elsif ['subscriber_all_stories', 'subscriber', 'editor', 'staff', 'reader', 'guest'].include?(user.role)
							ArticleMailer.delay.send_article_full(@article, user)
						end
					else
					end
				end
				end
			end
		elsif @article.email_to == 'readers' && @article.type.name == 'BLOG'
			User.totalreaders.each do |user|
				ArticleMailer.delay.send_article_full(@article, user)
		end
		elsif @article.email_to == 'subscribers' && @article.type.name == 'BLOG'
			User.totalsubscribers.each do |user|
				ArticleMailer.delay.send_article_full(@article, user)
		end
		else
		end
	end
  
  def stories_last_active
    @article.stories.each do |s|
      s.touch
    end
  end
  
  def new_breaking_story
    if params[:new_story] == '1' && ["breaking", "majorbreaking"].include?(@article.urgency)
      s = Story.new
      s.story = @article.short_headline
      s.description = 'Breaking news: ' + @article.short_headline + '. More to follow.'
      s.category_id = 17
      s.save
      
      @article.stories << s
    else
    end
  end

  # POST /articles
  # POST /articles.json
  def create
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @article = Article.new(article_params)
      respond_to do |format|
        if @article.save && ["draft", "editing"].include?(@article.status)
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        elsif @article.save && ["published", "updated"].include?(@article.status)
          new_breaking_story
          twitter
          stories_last_active
          emailarticles
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { redirect_to edit_article_path(@article) }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end  
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @article.update(article_params) && ["draft", "editing"].include?(@article.status)
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully updated.' }
          format.json { render :show, status: :created, location: @article }
        elsif @article.update(article_params) && ["published", "updated"].include?(@article.status)
          twitter
          stories_last_active
          emailarticles
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully updated.' }
          format.json { render :show, status: :ok, location: @article }
        else
          format.html { redirect_to edit_article_path(@article), notice: 'Article was successfully updated.' }
          format.json { render :show, status: :ok, location: @article }
        end
      end
    else
      redirect_to root_url
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
      params.require(:article).permit(:body, :briefing_point, :caption, :created_at, :email_to, :is_free, :headline, :lede, :main, :notification_slug, :notification_message, :remove_main, :short_lede, :short_slug, :short_headline, :status, :source, :topstory, :type_id, :updated_at, :urgency, :video, :summary, :summary_slug, :category_ids => [], :region_ids => [], :story_ids => [], :user_ids => [])
    end
end
