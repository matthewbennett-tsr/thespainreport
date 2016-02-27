class WelcomeController < ApplicationController

  def index
    @lasttopstory = Article.bignews.lastone
    @lasteditorial = Article.editorial.lastone
    @lastindepth = Article.in_depth.lastone
    @lastpolitics = Article.published.politics.lastfive
    @lasteconomy = Article.published.economy.lastfive
    @lastdiplomacy = Article.published.diplomacy.lastfive
    @last10 = Article.published.lastten.not_blog
    @last30items = Newsitem.published.lastthirty
    @breakingonly = Article.breakingonly.published.latest.ticker
    @latestaudio = Audio.lastone
    @tickerstories = Article.bignews.published.latest.ticker
  end

end