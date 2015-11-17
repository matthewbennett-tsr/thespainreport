class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  
  before_filter :allow_iframe_requests
  before_filter :set_visitor_cookie
  
  def set_visitor_cookie
    cookies[:visits] = {
      value: increment_counter,
      expires: 1.year.from_now
      }
    
    paywall
  end
  
  def increment_counter
    @pageviews = cookies[:visits].to_i
    if @pageviews.nil?
      @pageviews == 0
    end
      @pageviews += 1
  end

  def paywall
    cookies[:visits].to_i > 9
  end
  helper_method :paywall
  
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