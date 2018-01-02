class Story < ActiveRecord::Base
  has_and_belongs_to_many :newsitems
  has_and_belongs_to_many :articles
  belongs_to :category
  has_many :notifications, dependent: :destroy
  has_many :users, :through => :notifications
  
  before_save :story_notifications
  
  def to_param
  "#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{story.parameterize}"
  end
  
  scope :bignews, -> {where(:urgency => ['latest', 'breaking', 'majorbreaking'])}
  scope :latest, -> {order('last_active DESC NULLS LAST, story ASC').limit(5)}
  scope :ticker, -> {limit(1)}
  scope :active, -> {where(:status => ['active'])}
  
  def story_notifications
    User.all.each do |u|
      Notification.where(user_id: u.id, story_id: self.id).first_or_create(notificationtype_id: 1)
    end
  end
  
end