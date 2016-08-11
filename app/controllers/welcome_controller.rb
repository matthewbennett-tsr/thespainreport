class WelcomeController < ApplicationController

  def index
    @lasttopstory = Article.topstory.published.lastone
    @lasttwenty = Article.published.lasttwenty.not_latest_top_story.not_latest_editorial.not_latest_in_depth.not_blog
    @lasteditorial = Article.editorial.published.lastone
    @lastindepth = Article.in_depth.published.lastone
    @latestupdates = Newsitem.published.lastten
    @breakingonly = Article.breakingonly.published.latest.ticker
    @latestaudio = Audio.lastone
    @tickerstories = Article.bignews.published.latest.ticker
    @indepth = Article.in_depth.published
  end

end