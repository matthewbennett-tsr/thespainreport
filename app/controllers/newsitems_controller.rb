class NewsitemsController < ApplicationController
  before_action :set_newsitem, only: [:show, :edit, :update, :destroy]

  # GET /newsitems
  # GET /newsitems.json
  def index
    @last30items = Newsitem.published.lastthirty
    @last50items = Newsitem.published.lastfifty
  end
  
  # GET /newsitems/admin
  # GET /newsitems/admin.json
  def admin
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @newsitems = Newsitem.all.order( 'newsitems.updated_at DESC' )
      @updatecount = Newsitem.count
      @updatesbymonth = Newsitem.all.order('created_at DESC').group_by { |t| t.created_at.beginning_of_month }
      @updatesbyweek = Newsitem.all.order('created_at DESC').group_by { |t| t.created_at.beginning_of_week }
    else
      redirect_to root_url
    end
  end

  # GET /newsitems/1
  # GET /newsitems/1.json
  def show
    @region = Newsitem.find(params[:id])
    @category = Newsitem.find(params[:id])
    @story = Newsitem.find(params[:id])
    @latestaudio = Audio.lastone
    @comments = @newsitem.comments
    @last30items = Newsitem.published.lastthirty
    @updateslast24 = Newsitem.last24
  end

  # GET /newsitems/new
  def new
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @newsitemarticle = Article.published.lastthirty
      @newsitem = Newsitem.new
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
    else
      redirect_to root_url
    end
  end

  # GET /newsitems/1/edit
  def edit
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @newsitemarticle = Article.published.lastthirty
      @regions = Region.all.order(:region)
      @categories = Category.all.order(:category)
      @stories = Story.all.order(:story)
    else
      redirect_to root_url
    end 	
  end

  def twitter
    if @newsitem.main? && params[:tweet] == '1'
      $client.update_with_media(tweet, open(tweetimage))
    elsif params[:tweet] == '1'
      $client.update(tweet)
    else
    end
  end

  def tweet
    if @newsitem.video?
      updateslug + updatetext + ' ' + updatelink + ' ' + tweetvideo
    else
      updateslug + updatetext + ' ' + updatelink
    end
  end

  def updateslug
    if @newsitem.short_slug?
      @newsitem.short_slug + ': '
    elsif @newsitem.article.present? && @newsitem.article.type.name == "LIVE BLOG"
      'LIVE BLOG: '
    else
      'LATEST: '
    end
  end

  def updatetext
    if @newsitem.short_headline?
      @newsitem.short_headline
    else
      @newsitem.slug
    end
  end

  def updatelink
    if @newsitem.article.present?
      article_url(@newsitem.article) + '#' + @newsitem.id.to_s
    else
      newsitem_url(@newsitem)
    end
  end
  
  def updatelinktest
    if @newsitem.article.present? && @newsitem.article.type.name == "LIVE BLOG"
      'https://www.thespainreport.com/live-blog/#' + @newsitem.id.to_s
    else
      'https://www.thespainreport.com/'
    end
  end

  def tweetimage
    @newsitem.main.url
  end
  
  def tweetvideo
   'https://www.youtube.com/watch?v=' + @newsitem.video
  end

  def email
    if @newsitem.email_to == 'none'
    
    elsif @newsitem.email_to == 'test'
      User.editors.each do |user|
        NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
      end
    elsif @newsitem.email_to == 'all' 
      if @newsitem.article.is_free || ["BLOG", "LIVE BLOG", "VIDEO BLOG"].include?(@newsitem.article.type.try(:name))
        User.notdeleted.each do |user|
          NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
	    end
      else
        User.notdeleted.each do |user|
        Notification.where(user_id: user.id, story_id: @newsitem.article.story_ids, notificationtype_id: 1).first(1).each do
          if user.access_date.blank?
            NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
          elsif user.access_date < Time.current
            if ['reader', 'guest'].include?(user.role)
              NewsitemMailer.delay.send_newsitem_subscribe(@newsitem, user)
            elsif ['subscriber_one_story', 'subscriber_all_stories', 'subscriber'].include?(user.role)
              NewsitemMailer.delay.send_newsitem_resubscribe(@newsitem, user)
            end
          elsif user.access_date >= Time.current
            if user.role == 'subscriber_one_story'
              if ["RECAP"].include?(@newsitem.article.type.try(:name))
                NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
              elsif @newsitem.article.story_ids.include?(user.one_story_id)
                NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
              elsif @newsitem.article.story_ids.exclude?(user.one_story_id)
                NewsitemMailer.delay.send_newsitem_upgrade(@newsitem, user)
              end
            elsif ['subscriber_all', 'subscriber', 'editor', 'staff', 'reader', 'guest'].include?(user.role)
              NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
            end
          else
          end
        end
        end
      end
    elsif @newsitem.email_to == 'readers' && @newsitem.type.name == 'BLOG'
      User.totalreaders.each do |user|
        NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
	  end
    elsif @newsitem.email_to == 'subscribers' && @newsitem.type.name == 'BLOG'
      User.totalsubscribers.each do |user|
        NewsitemMailer.delay.send_newsitem_full(@newsitem, user)
	  end
    else
    end
  end

  # POST /newsitems
  # POST /newsitems.json
  def create
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @newsitem = Newsitem.new(newsitem_params)
      respond_to do |format|
        if @newsitem.save && ["draft", "editing"].include?(@newsitem.status)
          format.html { redirect_to edit_newsitem_path(@newsitem), notice: 'Update was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        elsif @newsitem.save && ["published", "updated"].include?(@newsitem.status)
          @newsitem.article.touch
          twitter
          email
          format.html { redirect_to edit_newsitem_path(@newsitem), notice: 'Update was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        elsif @newsitem.save
          format.html { redirect_to edit_newsitem_path(@newsitem), notice: 'Update was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { redirect_to edit_newsitem_path(@newsitem) }
          format.json { render json: @newsitem.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url
    end
  end

  # PATCH/PUT /newsitems/1
  # PATCH/PUT /newsitems/1.json
  def update
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      respond_to do |format|
        if @newsitem.update(newsitem_params) && ["draft", "editing"].include?(@newsitem.status)
          format.html { redirect_to edit_newsitem_path(@newsitem), notice: 'Newsitem was successfully updated.' }
          format.json { render :show, status: :ok, location: @newsitem }
        elsif @newsitem.update(newsitem_params) && ["published", "updated"].include?(@newsitem.status)
          @newsitem.article.touch
          twitter
          email
          format.html { redirect_to edit_newsitem_path(@newsitem), notice: 'Newsitem was successfully updated.' }
          format.json { render :show, status: :ok, location: @newsitem }
        elsif @newsitem.update(newsitem_params)
          format.html { redirect_to edit_newsitem_path(@newsitem), notice: 'Update was successfully created.' }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { redirect_to edit_newsitem_path(@newsitem) }
          format.json { render json: @newsitem.errors, status: :unprocessable_entity }
        end
      end  
    else
      redirect_to root_url
    end
  end

  # DELETE /newsitems/1
  # DELETE /newsitems/1.json
  def destroy
    if current_user.nil? 
      redirect_to root_url
    elsif current_user.role == 'editor'
      @newsitem.destroy
      respond_to do |format|
        format.html { redirect_to :action => 'admin', notice: 'Newsitem was successfully destroyed.' }
        format.json { head :no_content }
      end   
    else
      redirect_to root_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_newsitem
      @newsitem = Newsitem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def newsitem_params
      params.require(:newsitem).permit(:article_id, :briefing_point, :caption, :created_at, :email_to, :imagesource, :item, :main, :source, :status, :updated_at, :remove_main, :short_slug, :short_headline, :slug, :url, :video, :summary, :summary_slug, :region_ids => [], :category_ids => [], :story_ids => [])
    end
end
