class PasswordResetsController < ApplicationController
  def new
  end

  def create
  user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      flash[:success] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:notice] = "Whoops…e-mail address not found…try again."
      render 'new'
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
  @user = User.find_by_password_reset_token!(params[:id])
  if @user.password_reset_sent_at < 2.hours.ago
    redirect_to new_password_reset_path, :alert => "Password &crarr; 
      reset has expired."
  elsif @user.update_attributes(params.permit![:user])
    redirect_to root_url
    flash[:success] = "Well done! You have a new password. Now log in."
  else
    render :edit
  end
  end
  
end
