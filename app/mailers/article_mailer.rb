class ArticleMailer < ApplicationMailer
  helper ApplicationHelper
  default :from => "The Spain Report <subscriptions@thespainreport.com>"

  def send_article_full new_mail, user
    @article = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_article_subject)
  end
  
  def send_article_subscribe new_mail, user
    @article = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_article_subject)
  end
  
  def send_article_resubscribe new_mail, user
    @article = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_article_subject)
  end
  
  def send_article_upgrade new_mail, user
    @article = new_mail
    @user = user
    mail(:to => "<#{user.email}>", :subject => send_article_subject)
  end
  
  def send_briefing_2(user)
    @user = user
    @briefingstories = @user.stories.where(notifications: {notificationtype_id: 2}).ids
    @briefing_articles = Article.last2.published.order("created_at DESC").joins(:stories).where(stories: {id: @briefingstories}).distinct
    mail(:to => "<#{user.email}>", :subject => "My Spain Briefing", template_name: 'send_briefing')
  end
  
  def send_briefing_3(user)
    @user = user
    @briefingstories = @user.stories.where(notifications: {notificationtype_id: 2}).ids
    @briefing_articles = Article.last3.published.order("created_at DESC").joins(:stories).where(stories: {id: @briefingstories}).distinct
    mail(:to => "<#{user.email}>", :subject => "My Spain Briefing", template_name: 'send_briefing')
  end
  
  def send_briefing_6(user)
    @user = user
    @briefingstories = @user.stories.where(notifications: {notificationtype_id: 2}).ids
    @briefing_articles = Article.last6.published.order("created_at DESC").joins(:stories).where(stories: {id: @briefingstories}).distinct
    mail(:to => "<#{user.email}>", :subject => "My Spain Briefing", template_name: 'send_briefing')
  end
  
  def send_briefing_12(user)
    @user = user
    @briefingstories = @user.stories.where(notifications: {notificationtype_id: 2}).ids
    @briefing_articles = Article.last12.published.order("created_at DESC").joins(:stories).where(stories: {id: @briefingstories}).distinct
    mail(:to => "<#{user.email}>", :subject => "My Spain Briefing", template_name: 'send_briefing')
  end
  
  def send_briefing_24(user)
    @user = user
    @briefingstories = @user.stories.where(notifications: {notificationtype_id: 2}).ids
    @briefing_articles = Article.last24.published.order("created_at DESC").joins(:stories).where(stories: {id: @briefingstories}).distinct
    mail(:to => "<#{user.email}>", :subject => "My 9 a.m. Spain Briefing", template_name: 'send_briefing')
  end
  
  def send_briefing_48(user)
    @user = user
    @briefingstories = @user.stories.where(notifications: {notificationtype_id: 2}).ids
    @briefing_articles = Article.last48.published.order("created_at DESC").joins(:stories).where(stories: {id: @briefingstories}).distinct
    mail(:to => "<#{user.email}>", :subject => "My Sunday Morning Spain Briefing", template_name: 'send_briefing')
  end
  
  def send_briefing_84(user)
    @user = user
    @briefingstories = @user.stories.where(notifications: {notificationtype_id: 2}).ids
    @briefing_articles = Article.last84.published.order("created_at DESC").joins(:stories).where(stories: {id: @briefingstories}).distinct
    mail(:to => "<#{user.email}>", :subject => "My Twice Weekly Spain Briefing", template_name: 'send_briefing')
  end
  
  def send_briefing_168(user)
    @user = user
    @briefingstories = @user.stories.where(notifications: {notificationtype_id: 2}).ids
    @briefing_articles = Article.last168.published.order("created_at DESC").joins(:stories).where(stories: {id: @briefingstories}).distinct
    mail(:to => "<#{user.email}>", :subject => "My Weekly Spain Briefing", template_name: 'send_briefing')
  end
  
  def send_article_subject
    if @article.notification_slug?
      @article.notification_slug + ": " + send_article_headline
    elsif @article.urgency == 'majorbreaking'
      "MAJOR BREAKING: " + send_article_headline
    elsif @article.urgency == 'breaking'
      "BREAKING: " + send_article_headline
    elsif @article.urgency == 'morning' && @article.type.try(:name) == 'NEWS'
      "MORNING LEAD: " + send_article_headline
    elsif @article.urgency == 'evening' && @article.type.try(:name) == 'RECAP'
      "EVENING RECAP: " + send_article_headline
    else
      "#{@article.type.name}: " + send_article_headline
    end
  end
  
  def send_article_headline
    if @article.notification_message?
      @article.notification_message
    else
      @article.headline.present? ? @article.headline : @article.short_headline
    end
  end

end