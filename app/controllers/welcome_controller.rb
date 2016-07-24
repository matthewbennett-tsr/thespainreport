class WelcomeController < ApplicationController

  def index
    @lasttopstory = Article.topstory.published.lastone
    @lasteditorial = Article.editorial.published.lastone
    @lastindepth = Article.in_depth.published.lastone
    @lastpolitics = Article.published.politics.lastfive
    @lasteconomy = Article.published.economy.lastfive
    @lastdiplomacy = Article.published.diplomacy.lastfive
    @lasttwenty = Article.published.lasttwenty.not_top.not_blog
    @latestupdates = Newsitem.published.lastten
    @breakingonly = Article.breakingonly.published.latest.ticker
    @latestaudio = Audio.lastone
    @tickerstories = Article.bignews.published.latest.ticker
    @indepth = Article.in_depth.published
  end

end