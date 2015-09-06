class UserMailer < ApplicationMailer
  default :from => "The Spain Report <matthew@thespainreport.com>"

  def registration_confirmation(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Welcome to The Spain Report (I): confirm your e-mail")
  end
  
  def password_choose(user)
    @user = user
    mail to: user.email, subject: "Welcome to The Spain Report (II): choose your password"
  end
  
  def thank_you_for_subscribing(user)
    @user = user
    mail to: user.email, subject: "Welcome to The Spain Report (III): thank you for subscribing"
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset: click this link to reset your password"
  end

end
