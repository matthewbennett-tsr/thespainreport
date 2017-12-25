class NewsitemMailer < ApplicationMailer
  helper ApplicationHelper
  default :from => "The Spain Report <subscriptions@thespainreport.com>"

  def send_newsitem_full new_mail, user
    @newsitem = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_newsitem_subject)
  end
  
  def send_newsitem_subscribe new_mail, user
    @newsitem = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_newsitem_subject)
  end
  
  def send_newsitem_resubscribe new_mail, user
    @newsitem = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_newsitem_subject)
  end
  
  def send_newsitem_upgrade new_mail, user
    @newsitem = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_newsitem_subject)
  end
  
  def send_newsitem_subject
    if @newsitem.short_slug?
      @newsitem.short_slug + ": " + send_newsitem_headline
    elsif @newsitem.article.present? && @newsitem.article.type.name == "LIVE BLOG"
      "LIVE BLOG: " + send_newsitem_headline
    else
      "LATEST: " + send_newsitem_headline
    end
  end
  
  def send_newsitem_headline
    if @newsitem.short_headline?
      @newsitem.short_headline
    else
      @newsitem.slug
    end
  end
  
end