class Campaign < ActiveRecord::Base
	has_many :articles
	has_many :subscriptions

	mount_uploader :url, CampaignUploader
	
end