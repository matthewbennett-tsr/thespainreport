class SalesemailMailer < ApplicationMailer

  def send_onboard_email(email, user)
    @salesemail = email
    @user = user
    mail(:to => "<#{@user.email}>", :subject => "#{@salesemail.subject}")
  end
  
end