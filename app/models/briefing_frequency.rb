class BriefingFrequency < ActiveRecord::Base

  scope :onesixeight, -> {where(:briefing_frequency => 168)}

end
