class UserMailer < ApplicationMailer
  helper ApplicationHelper
  default :from => "The Spain Report <matthew@thespainreport.com>"
  
  def new_user_password_choose(user)
    @user = user
    mail to: user.email, subject: "Welcome to The Spain Report (1): choose a password and log in"
  end
  
  def new_user_story_notifications(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Welcome to The Spain Report (2): your story notifications")
  end
  
  def new_user_catch_up(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Welcome to The Spain Report (3): catch up with these articles")
  end
  
  def new_subscriber_thank_you(user)
    @user = user
    mail to: user.email, subject: "Thank you for subscribing to The Spain Report"
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset: click this link to reset your password"
  end

end
