class UserMailer < ApplicationMailer
  default :from => "The Spain Report <matthew@thespainreport.com>"

  def registration_confirmation(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Join: click this link to confirm your registration")
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset: click this link to reset your password"
  end

end
