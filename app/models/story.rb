class Story < ActiveRecord::Base
  has_and_belongs_to_many :newsitems
  has_and_belongs_to_many :articles
  
  def to_param
  "#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{story.parameterize}"
  end
  
  scope :bignews, -> {where(:urgency => ['latest', 'breaking', 'majorbreaking'])}
  scope :latest, -> {order('last_active DESC NULLS LAST, story ASC').limit(5)}
  scope :ticker, -> {limit(1)}
  scope :active, -> {where(:status => ['active'])}
end