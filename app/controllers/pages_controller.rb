class PagesController < ApplicationController

  def show
    @tickerstories = Story.bignews.latest.ticker
    render template: "pages/#{params[:page]}"
  end

end
