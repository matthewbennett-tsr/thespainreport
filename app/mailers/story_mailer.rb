class StoryMailer < ApplicationMailer
  default :from => "The Spain Report <subscriptions@thespainreport.com>"

  def send_story_alert new_mail, user
    @story = new_mail
    mail(:to => "<#{user.email}>", :subject => send_story_urgency)
  end
  
  def send_story_urgency
    if @story.urgency == 'majorbreaking'
      "MAJOR BREAKING NEWS LIVE BLOG: #{@story.story}"
    elsif @story.urgency == 'breaking'
      "BREAKING NEWS LIVE BLOG: #{@story.story}"
    elsif @story.urgency == 'latest'
      "LATEST NEWS LIVE BLOG: #{@story.story}"
    else
      
    end
  end
  
  
end