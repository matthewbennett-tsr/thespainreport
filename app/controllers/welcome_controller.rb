class WelcomeController < ApplicationController

  def index
    @lasttopstory = Article.bignews.published.lastone
    @lasteditorial = Article.editorial.published.lastone
    @lastindepth = Article.in_depth.published.lastone
    @lastpolitics = Article.published.politics.lastfive
    @lasteconomy = Article.published.economy.lastfive
    @lastdiplomacy = Article.published.diplomacy.lastfive
    @last10 = Article.published.lastten.not_blog
    @last30items = Newsitem.published.lastthirty
    @breakingonly = Article.breakingonly.published.latest.ticker
    @latestaudio = Audio.lastone
    @tickerstories = Article.bignews.published.latest.ticker
    @activestories = Story.active.order('story ASC')
  end

end