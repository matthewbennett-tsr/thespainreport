class WelcomeController < ApplicationController

  def index
    @last10 = Article.published.lastten.not_blog
    @last30items = Newsitem.published.lastthirty
    @breakingonly = Article.breakingonly.published.latest.ticker
    @latestaudio = Audio.lastone
    @tickerstories = Article.bignews.published.latest.ticker
  end

end