class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  
  before_filter :allow_iframe_requests
  before_filter :set_visitor_cookie
  before_filter :app_wide
  
  def app_wide
    @last_active_stories = Story.latest
    @lasteditorial = Article.editorial.published.lastone
    @lastmorning = Article.morning.published.lastone
    @lastevening = Article.evening.published.lastone
    @lastindepth = Article.in_depth.published.lastone
  end
  
  def message_error_not_allowed
    "You're not allowed to do that."
  end
  
  def set_visitor_cookie
    cookies[:visits] = {
      value: increment_counter,
      expires: 1.year.from_now
      }
    
    paywall
  end
  
  def increment_counter
  if controller_name == 'articles' && action_name == 'show' || controller_name == 'newsitems' && action_name == 'show'
    @pageviews = cookies[:visits].to_i
    if @pageviews.nil?
      @pageviews == 0
    end
      @pageviews += 1
  else
    @pageviews = cookies[:visits].to_i
  end
  end

  def paywall
    if controller_name == 'articles' && action_name == 'show'
      cookies[:visits].to_i > 5
    elsif controller_name == 'newsitems' && action_name == 'show'
      cookies[:visits].to_i > 5
    else
    end
  end
  helper_method :paywall
  
  def paywall_reader
    if controller_name == 'articles' && action_name == 'show'
      cookies[:visits].to_i > 10
    elsif controller_name == 'newsitems' && action_name == 'show'
      cookies[:visits].to_i > 15
    else
    end
  end
  helper_method :paywall_reader
  
  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end
  
end