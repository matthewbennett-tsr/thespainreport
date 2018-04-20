class Campaign < ActiveRecord::Base

	mount_uploader :url, CampaignUploader
	
end