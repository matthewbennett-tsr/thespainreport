namespace :briefings do

task :sundays => [:create_sunday_am_web_briefing, :briefing_sunday_10_am]
task :weekdays_10am => [:create_am_web_briefing, :briefing_monday_to_friday_10_am]
task :weekdays_10pm => [:create_pm_web_briefing, :briefing_monday_to_friday_10_pm]

  task :create_sunday_am_web_briefing => :environment do
    if Article.last48.notbriefing.published.present?
      a = Article.new
      a.type_id = 32
      a.status = 'published'
      a.headline = 'Spain Briefing: ' + Time.current.strftime("%A, %b %-d, %Y at %l:%M %p")
      a.short_headline = 'Spain Briefing: ' + Time.current.strftime("%d/%m/%y, %l:%M %p")
      a.lede = 'Sign up now to get these briefings in your inbox.'
      a.short_lede = 'Sign up now to get these briefings in your inbox.'
      a.body = web_sunday_am_briefing_article_text
      a.save!
    else
    end
  end

  task :briefing_sunday_10_am => :environment do
    User.notdeleted.each do |user|
      userid = user.id
      if [2,3,6,12,24].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_48(userid)
      elsif [84].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_84(userid)
      elsif [168].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_168(userid)
      else
      end
    end
  end

  task :create_am_web_briefing => :environment do
    if Article.last24.notbriefing.published.present?
      a = Article.new
      a.type_id = 32
      a.status = 'published'
      a.headline = 'Spain Briefing: ' + Time.current.strftime("%A, %b %-d, %Y at %l:%M %p")
      a.short_headline = 'Spain Briefing: ' + Time.current.strftime("%d/%m/%y, %l:%M %p")
      a.lede = 'Sign up now to get these briefings in your inbox.'
      a.short_lede = 'Sign up now to get these briefings in your inbox.'
      a.body = web_am_briefing_article_text
      a.save!
    else
    end
  end
  
  task :briefing_monday_to_friday_10_am => :environment do
    User.notdeleted.each do |user|
      userid = user.id
      if [2,3,6,12].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_12(userid)
      elsif [24].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_24(userid)
      else
      end
    end
  end

  task :briefing_every_2_hours => :environment do
    User.notdeleted.each do |user|
      userid = user.id
      if [2].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_2(userid)
      else
      end
    end
  end
  
  task :briefing_every_3_hours => :environment do
    User.notdeleted.each do |user|
      userid = user.id
      if [3].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_3(userid)
      else
      end
    end
  end
  
  task :briefing_monday_to_friday_4_pm => :environment do
    User.notdeleted.each do |user|
      userid = user.id
      if [2].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_2(userid)
      elsif [3].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_3(userid)
      elsif [6].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_6(userid)
      else
      end
    end
  end
  
  task :create_pm_web_briefing => :environment do
    if Article.last12.notbriefing.published.present?
      a = Article.new
      a.type_id = 32
      a.status = 'published'
      a.headline = 'Spain Briefing: ' + Time.current.strftime("%A, %b %-d, %Y at %l:%M %p")
      a.short_headline = 'Spain Briefing: ' + Time.current.strftime("%d/%m/%y, %l:%M %p")
      a.lede = 'Sign up now to get these briefings in your inbox.'
      a.short_lede = 'Sign up now to get these briefings in your inbox.'
      a.body = web_pm_briefing_article_text
      a.save!
    else
    end
  end
  
  task :briefing_monday_to_friday_10_pm => :environment do
    User.notdeleted.each do |user|
      userid = user.id
      if [2].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_2(userid)
      elsif [3].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_3(userid)
      elsif [6].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_6(userid)
      elsif [12].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_12(userid)
      else
      end
    end
  end
  
  task :briefing_wednesday_10pm => :environment do
    User.notdeleted.each do |user|
      userid = user.id
      if [84].include?(user.briefing_frequency.briefing_frequency)
        ArticleMailer.delay.send_briefing_84(userid)
      else
      end
    end
  end


  def web_sunday_am_briefing_article_text
    arr = Array.new
    Article.last48.notbriefing.published.each do |a|
    arr << "**" + a.short_headline.to_s + "**: " + a.briefing_point.to_s + " ([Read now](/articles/#{a.id}-#{a.created_at.strftime("%y%m%d%H%M%S")}-#{a.headline.parameterize}))"
    end
    arr.join("\n\n")
  end
  
  def web_am_briefing_article_text
    arr = Array.new
    Article.last24.notbriefing.published.each do |a|
    arr << "**" + a.short_headline.to_s + "**: " + a.briefing_point.to_s + " ([Read now](/articles/#{a.id}-#{a.created_at.strftime("%y%m%d%H%M%S")}-#{a.headline.parameterize}))"
    end
    arr.join("\n\n")
  end
  
  def web_pm_briefing_article_text
    arr = Array.new
    Article.last12.notbriefing.published.each do |a|
      arr << "**" + a.short_headline.to_s + "**: " + a.briefing_point.to_s + " ([Read now](/articles/#{a.id}-#{a.created_at.strftime("%y%m%d%H%M%S")}-#{a.headline.parameterize}))"
    end
    arr.join("\n\n")
  end
  
end