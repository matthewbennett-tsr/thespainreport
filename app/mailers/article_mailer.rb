class ArticleMailer < ApplicationMailer
  helper ApplicationHelper
  default :from => "The Spain Report <subscriptions@thespainreport.com>"

  def send_article_full new_mail, user
    @article = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_article_subject)
  end
  
  def send_article_teaser new_mail, user
    @article = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_article_subject)
  end
  
  def send_article_subject
    if @article.notification_slug?
      @article.notification_slug + ": " + send_article_headline
    elsif @article.urgency == 'majorbreaking'
      "MAJOR BREAKING: " + send_article_headline
    elsif @article.urgency == 'breaking'
      "BREAKING: " + send_article_headline
    elsif @article.urgency == 'latest'
      "LATEST: " + send_article_headline
    else
      "#{@article.type.name}: " + send_article_headline
    end
  end
  
  def send_article_headline
    if @article.notification_message?
      @article.notification_message
    else
      @article.headline
    end
  end

end