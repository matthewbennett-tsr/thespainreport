class SalesemailMailer < ApplicationMailer
  default :from => "The Spain Report <subscriptions@thespainreport.com>"
  
  def send_onboard_email(email, user)
    @salesemail = email
    @user = user
    mail(:to => "<#{@user.email}>", :subject => "#{@salesemail.subject}")
  end
  
end