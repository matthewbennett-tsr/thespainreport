namespace :sales do

task :all => [:onboard_1_day, :onboard_2_day, :onboard_3_day, :onboard_4_day, :onboard_5_day, :onboard_6_day, 
:onboard_7_day, :onboard_8_day, :onboard_9_day, :onboard_10_day, :onboard_11_day, :onboard_12_day, :onboard_13_day, 
:onboard_14_day, :onboard_15_day, :onboard_16_day, :onboard_17_day, :onboard_18_day, :onboard_19_day, :onboard_20_day, 
:onboard_21_day]

desc "Sends onboarding e-mail(s) to readers after 1 day"
task :onboard_1_day => :environment do
  salesemail = Salesemail.readers.one.days
  user = User.readers.oneday
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 2 days"
task :onboard_2_day => :environment do
  salesemail = Salesemail.readers.two.days
  user = User.readers.twodays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 3 days"
task :onboard_3_day => :environment do
  salesemail = Salesemail.readers.three.days
  user = User.readers.threedays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 4 days"
task :onboard_4_day => :environment do
  salesemail = Salesemail.readers.four.days
  user = User.readers.fourdays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 5 days"
task :onboard_5_day => :environment do
  salesemail = Salesemail.readers.five.days
  user = User.readers.fivedays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 6 days"
task :onboard_6_day => :environment do
  salesemail = Salesemail.readers.six.days
  user = User.readers.sixdays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 7 days"
task :onboard_7_day => :environment do
  salesemail = Salesemail.readers.seven.days
  user = User.readers.sevendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 8 days"
task :onboard_8_day => :environment do
  salesemail = Salesemail.readers.eight.days
  user = User.readers.eightdays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 9 days"
task :onboard_9_day => :environment do
  salesemail = Salesemail.readers.nine.days
  user = User.readers.ninedays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 10 days"
task :onboard_10_day => :environment do
  salesemail = Salesemail.readers.ten.days
  user = User.readers.tendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 11 days"
task :onboard_11_day => :environment do
  salesemail = Salesemail.readers.eleven.days
  user = User.readers.elevendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 12 days"
task :onboard_12_day => :environment do
  salesemail = Salesemail.readers.twelve.days
  user = User.readers.twelvedays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 13 days"
task :onboard_13_day => :environment do
  salesemail = Salesemail.readers.thirteen.days
  user = User.readers.thirteendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 14 days"
task :onboard_14_day => :environment do
  salesemail = Salesemail.readers.fourteen.days
  user = User.readers.fourteendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 15 days"
task :onboard_15_day => :environment do
  salesemail = Salesemail.readers.fifteen.days
  user = User.readers.fifteendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 16 days"
task :onboard_16_day => :environment do
  salesemail = Salesemail.readers.sixteen.days
  user = User.readers.sixteendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 17 days"
task :onboard_17_day => :environment do
  salesemail = Salesemail.readers.seventeen.days
  user = User.readers.seventeendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 18 days"
task :onboard_18_day => :environment do
  salesemail = Salesemail.readers.eighteen.days
  user = User.readers.eighteendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 19 days"
task :onboard_19_day => :environment do
  salesemail = Salesemail.readers.nineteen.days
  user = User.readers.nineteendays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 20 days"
task :onboard_20_day => :environment do
  salesemail = Salesemail.readers.twenty.days
  user = User.readers.twentydays
  if user.present? && salesemail.present?
    user.each do |user|
      salesemail.each do |email|
        SalesemailMailer.delay.send_onboard_email(email, user)
      end
    end
  else
  end
end

desc "Sends onboarding e-mail(s) to readers after 21 days"
task :onboard_21_day => :environment do
  salesemail = Salesemail.readers.twentyone.days
  user = User.readers.twentyonedays
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