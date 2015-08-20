class Newsitem < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :stories
  belongs_to :article
  has_many :comments, as: :commentable

  mount_uploader :main, MainUploader
  
  def to_param
  "#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-update-#{slug.parameterize}"
  end
  
  scope :published, -> {where(status: ['published', 'updated'])}
  scope :lastthirty, -> {order('updated_at DESC').limit(30)}
  scope :lastfifty, -> {order('updated_at DESC').limit(50)}
end
