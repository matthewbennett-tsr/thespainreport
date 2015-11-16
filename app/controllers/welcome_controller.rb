class WelcomeController < ApplicationController
  def index
    @last10 = Article.published.lastten.not_blog
    @last30items = Newsitem.published.lastthirty
    @tickerstories = Article.bignews.latest.ticker
    @breakingonly = Article.breakingonly.latest.ticker
    @latestaudio = Audio.lastone
  end
end