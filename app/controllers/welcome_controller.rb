class WelcomeController < ApplicationController
  def index
    @last10 = Article.published.lastten.not_blog
    @last30items = Newsitem.published.lastthirty
    @tickerstories = Story.bignews.latest.ticker
    @latestaudio = Audio.lastone
  end
end