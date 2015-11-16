class PagesController < ApplicationController

  def show
    @tickerstories = Article.bignews.latest.ticker
    render template: "pages/#{params[:page]}"
  end

end
