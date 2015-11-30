class NewsitemMailer < ApplicationMailer
  default :from => "The Spain Report <subscriptions@thespainreport.com>"

  def send_newsitem_full new_mail, user
    @newsitem = new_mail
    mail(:to => "<#{user.email}>", :subject => send_newsitem_subject)
  end
  
  def send_newsitem_teaser new_mail, user
    @newsitem = new_mail
    mail(:to => "<#{user.email}>", :subject => send_newsitem_subject)
  end
  
  def send_newsitem_subject
    if @newsitem.article.present? && @newsitem.article.type.name == "LIVE BLOG"
      "LIVE BLOG UPDATE: #{@newsitem.slug}"
    else
      "UPDATE: #{@newsitem.slug}"
    end
  end
  
end