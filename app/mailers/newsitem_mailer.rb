class NewsitemMailer < ApplicationMailer
  default :from => "The Spain Report <subscriptions@thespainreport.com>"

  def send_newsitem_full new_mail, user
    @newsitem = new_mail
    mail(:to => "<#{user.email}>", :subject => "UPDATE: #{@newsitem.slug}")
  end

end