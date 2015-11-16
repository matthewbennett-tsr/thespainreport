namespace :sales do

task :all => [:onboard_one, :onboard_two]

desc "Sends onboarding e-mail(s) to readers after 5 min"
task :onboard_5_min => :environment do
  salesemail = Salesemail.readers.one.hours
  user = User.readers.onehour
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 15 minutes"
task :onboard_15_min => :environment do
  salesemail = Salesemail.readers.two.hours
  user = User.readers.twohours
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 30 minutes"
task :onboard_30_min => :environment do
  salesemail = Salesemail.readers.two.hours
  user = User.readers.twohours
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 1 hour"
task :onboard_1_hour => :environment do
  salesemail = Salesemail.readers.one.hours
  user = User.readers.onehour
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

end