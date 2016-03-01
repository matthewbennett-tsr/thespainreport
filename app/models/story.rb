class Story < ActiveRecord::Base
  has_and_belongs_to_many :newsitems
  has_and_belongs_to_many :articles
  
  def to_param
  "#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{story.parameterize}"
  end
  
  scope :bignews, -> {where(:urgency => ['latest', 'breaking', 'majorbreaking'])}
  scope :latest, -> {order('updated_at DESC').where(:updated_at => (Time.now - 24.hours)..Time.now)}
  scope :ticker, -> {limit(1)}
  scope :active, -> {where(:status => ['active'])}
end
