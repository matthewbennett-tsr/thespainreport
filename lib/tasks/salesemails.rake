namespace :sales do

task :all => [:onboard_1_min, :onboard_2_min, :onboard_3_min, :onboard_4_min]

desc "Sends onboarding e-mail(s) to readers after 1 min"
task :onboard_1_min => :environment do
  salesemail = Salesemail.readers.one.minutes
  user = User.readers.oneminute
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 2 minutes"
task :onboard_2_min => :environment do
  salesemail = Salesemail.readers.two.minutes
  user = User.readers.twominutes
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 3 minutes"
task :onboard_3_min => :environment do
  salesemail = Salesemail.readers.three.minutes
  user = User.readers.threeminutes
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 4 minutes"
task :onboard_4_min => :environment do
  salesemail = Salesemail.readers.four.minutes
  user = User.readers.fourminutes
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