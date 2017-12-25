class SessionsController < ApplicationController

  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      # Save the user id inside the browser cookie. This is how we keep the user 
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      redirect_to :back
      flash[:success] = "Welcome back!"
    else
    # If user's login doesn't work, send them back to the login form.
      redirect_to :back
      flash[:notice] = "Please try again…<a href=\"#{new_password_reset_path}\" style=\"color: #005BBF !important; text-decoration:underline !important;\">Forgotten your password?</a>"
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to '/'
    flash[:success] = "Thanks for reading!"
  end

end