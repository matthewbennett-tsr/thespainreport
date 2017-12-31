class Story < ActiveRecord::Base
  has_and_belongs_to_many :newsitems
  has_and_belongs_to_many :articles
  belongs_to :category
  has_many :notifications, dependent: :destroy
  has_many :users, :through => :notifications
  
  after_create :new_story_notifications
  
  def to_param
  "#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{story.parameterize}"
  end
  
  scope :bignews, -> {where(:urgency => ['latest', 'breaking', 'majorbreaking'])}
  scope :latest, -> {order('last_active DESC NULLS LAST, story ASC').limit(5)}
  scope :ticker, -> {limit(1)}
  scope :active, -> {where(:status => ['active'])}
  
  def new_story_notifications
    User.all.each do |u|
      n = Notification.new
      n.story_id = self.id
      n.user_id = u.id
      n.notificationtype_id = 1
      n.save!
    end
  end
  
end