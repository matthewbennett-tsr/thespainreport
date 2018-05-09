class Campaign < ActiveRecord::Base
	has_many :articles

	mount_uploader :url, CampaignUploader
	
end