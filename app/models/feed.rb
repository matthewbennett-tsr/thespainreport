require 'digest/md5'
class Feed < ActiveRecord::Base
  has_many :entries, dependent: :destroy

  validates :url, uniqueness: true
  
  CATEGORIES = %i[world_home world_politics world_economy world_foreign_affairs world_media spain_english spain_all spain_home spain_opinion spain_international spain_national spain_economy spain_other]

  scope :world_all, -> {where(category: ['world_home', 'world_politics', 'world_economy', 'world_foreign_affairs', 'world_media'])}
  scope :world_home, -> {where(category: 'world_home')}
  scope :world_politics, -> {where(category: 'world_politics')}
  scope :world_economy, -> {where(category: 'world_economy')}
  scope :world_foreign_affairs, -> {where(category: 'world_foreign_affairs')}
  scope :world_media, -> {where(category: 'world_media')}
  scope :spain_english, -> {where(category: 'spain_english')}
  scope :spain_all, -> {where(category: ['spain_english', 'spain_home', 'spain_opinion', 'spain_international', 'spain_national', 'spain_economy', 'spain_other'])}
  scope :spain_home, -> {where(category: 'spain_home')}
  scope :spain_opinion, -> {where(category: 'spain_opinion')}
  scope :spain_international, -> {where(category: 'spain_international')}
  scope :spain_national, -> {where(category: 'spain_national')}
  scope :spain_economy, -> {where(category: 'spain_economy')}
  scope :spain_other, -> {where(category: 'spain_other')}
  
  def secret
		Digest::MD5.hexdigest(created_at.to_s)
  end

  def notified params
    update_attributes(:status => params["status"]["http"])

  	params['items'].each do |i|
  		entries.create(:atom_id => i["id"], :title => i["title"], :url => i["permalinkUrl"])
  	end
  end
end