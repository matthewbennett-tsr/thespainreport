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
    if @article.urgency == 'majorbreaking'
      "MAJOR BREAKING: #{@article.headline}"
    elsif @article.urgency == 'breaking'
      "BREAKING: #{@article.headline}"
    elsif @article.urgency == 'latest'
      "LATEST: #{@article.headline}"	
    else
      "#{@article.type.name}: #{@article.headline}"
    end
  end

end