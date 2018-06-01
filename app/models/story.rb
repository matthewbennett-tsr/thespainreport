class Story < ActiveRecord::Base
  has_and_belongs_to_many :newsitems
  has_and_belongs_to_many :articles
  belongs_to :category
  has_many :notifications, dependent: :destroy
  has_many :users, :through => :notifications
  
  after_update :story_notifications
  after_create :story_notifications
  
  def to_param
  "#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{story.parameterize}"
  end
  
  scope :bignews, -> {where(:urgency => ['latest', 'breaking', 'majorbreaking'])}
  scope :latest, -> {order('last_active DESC NULLS LAST, story ASC').limit(5)}
  scope :ticker, -> {limit(1)}
  scope :active, -> {where(:status => ['active'])}
  scope :nowactive, -> {where(:updated_at => 168.hours.ago..DateTime.now.in_time_zone)}
  scope :notnowactive, -> {where.not(:updated_at => 168.hours.ago..DateTime.now.in_time_zone)}
  scope :keystories, -> {where(:id => [60, 61, 62, 84])}
  scope :notkeystories, -> {where.not(:id => [60, 61, 62, 84])}
  
  def story_notifications
    User.active.each do |u|
      u.notifications.where(story_id: self.id).first_or_create(notificationtype_id: 1)
    end
  end
  
end