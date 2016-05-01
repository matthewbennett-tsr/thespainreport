class UserMailer < ApplicationMailer
  helper ApplicationHelper
  default :from => "The Spain Report <matthew@thespainreport.com>"

  def registration_confirmation(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Welcome to The Spain Report (1): confirm your e-mail")
  end
  
  def password_choose(user)
    @user = user
    mail to: user.email, subject: "Welcome to The Spain Report (2): choose your password"
  end
  
  def new_user_stories(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Welcome to The Spain Report (3): catch up with these articles")
  end
  
  def new_user_indepth(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Welcome to The Spain Report (4): FREE in-depth article")
  end
  
  def new_user_editorial(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Welcome to The Spain Report (5): FREE editorial")
  end
  
  def thank_you_for_subscribing(user)
    @user = user
    mail to: user.email, subject: "Welcome to The Spain Report: thank you for subscribing"
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset: click this link to reset your password"
  end

end
