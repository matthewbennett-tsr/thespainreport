class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :retrieve]

  # GET /feeds
  # GET /feeds.json
  def feed_count
    @feed_count = Feed.count
  end
  
  def index
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @feeds = Feed.all
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
    
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /feeds/new
  def new
    if current_user.nil? 
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    elsif current_user.role == 'editor'
      @feed = Feed.new
    else
      redirect_to root_url
      flash[:success] = "Now then, now then, you're not allowed to do that."
    end
  end

  # GET /feeds/1/edit
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

  # GET /feeds/1/retrieve
  def retrieve
    body, ok = SuperfeedrEngine::Engine.retrieve(@feed)
    if !ok
      redirect_to @feed , notice: body
    else
      @feed.notified JSON.parse(body)
      redirect_to @feed , notice: "Retrieved and saved entries"
    end
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)

    if @feed.save
      body, ok = SuperfeedrEngine::Engine.subscribe(@feed, {:retrieve => true})
      if !ok
        redirect_to @feed, notice: "Feed was successfully created but we could not subscribe: #{body}"
      else
        if body
          @feed.notified JSON.parse(body)
        end
        redirect_to @feed, notice: 'Feed was successfully created and subscribed!'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    if @feed.update(feed_params)
      body, ok = SuperfeedrEngine::Engine.unsubscribe(@feed)
      if !ok
        render :edit, notice: "Feed was successfully updated, but we could not unsubscribe and resubscribe it. #{body}"
      else
        body, ok = SuperfeedrEngine::Engine.subscribe(@feed)
        if !ok
          render :edit, notice: "Feed was successfully updated, but we could not unsubscribe and resubscribe it. #{body}"
        else
          redirect_to @feed, notice: 'Feed was successfully updated.'
        end
      end
    else
      render :edit
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    body, ok =  SuperfeedrEngine::Engine.unsubscribe(@feed)
    if !ok
      redirect_to @feed, notice: body
    else
      @feed.destroy
      redirect_to feeds_url, notice: 'Feed was successfully destroyed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:title, :url, :status, :category, :slug)
    end
end
