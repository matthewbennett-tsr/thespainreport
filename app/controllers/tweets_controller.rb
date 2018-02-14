class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  # GET /tweets
  # GET /tweets.json
	def index
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 'editor'
			@tweets = Tweet.all
		else
			redirect_to root_url
		end
	end

	# GET /tweets/1
	# GET /tweets/1.json
	def show
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 'editor'
			
		else
			redirect_to root_url
		end
	end

	# GET /tweets/new
	def new
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 'editor'
			@tweet = Tweet.new
			@tweetarticle = Article.published.lastthirty
		else
			redirect_to root_url
		end
	end

	# GET /tweets/1/edit
	def edit
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 'editor'
			@tweetarticle = Article.published.lastthirty
		else
			redirect_to root_url
		end
	end

	def twitter
		if params[:sendtweet] == '1'
			$client.update(@tweet.message + ' ' + tweetlink)
		else
		end
	end
	
	def tweetlink
		if @tweet.article.present?
			article_url(@tweet.article)
		else
		end
	end

	# POST /tweets
	# POST /tweets.json
	def create
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 'editor'
			@tweet = Tweet.new(tweet_params)
			respond_to do |format|
				if @tweet.save
					twitter
					format.html { redirect_to new_tweet_path, notice: 'Tweet was successfully created.' }
					format.json { render :show, status: :created, location: @tweet }
				else
					format.html { render :new }
					format.json { render json: @tweet.errors, status: :unprocessable_entity }
				end
			end
		else
			redirect_to root_url
		end
	end

	# PATCH/PUT /tweets/1
	# PATCH/PUT /tweets/1.json
	def update
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 'editor'
			respond_to do |format|
				if @tweet.update(tweet_params)
					twitter
					format.html { redirect_to edit_tweet_path(@tweet), notice: 'Tweet was successfully updated.' }
					format.json { render :edit, status: :ok, location: @tweet }
				else
					format.html { render :edit }
					format.json { render json: @tweet.errors, status: :unprocessable_entity }
				end
			end
		else
			redirect_to root_url
		end
	end

	# DELETE /tweets/1
	# DELETE /tweets/1.json
	def destroy
		if current_user.nil? 
			redirect_to root_url
		elsif current_user.role == 'editor'
			@tweet.destroy
			respond_to do |format|
				format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
				format.json { head :no_content }
			end
		else
			redirect_to root_url
		end
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:article_id, :message)
    end
    
end
