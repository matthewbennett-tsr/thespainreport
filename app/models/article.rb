class Article < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :stories
  belongs_to :type
  has_many :newsitems
  has_many :comments, as: :commentable, dependent: :destroy
  
  mount_uploader :main, MainUploader
  
  def to_param
  "#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{headline.parameterize}"
  end
  
  def self.tickerstories
    Article.bignews.published.latest.ticker
  end
  
  scope :is_blog, -> {where(:type_id => 26)}
  scope :not_blog, -> {where.not(:type_id => 26)}
  scope :topstory, -> {where(:topstory => true)}
  scope :not_top, -> {where(:topstory => false)}
  scope :not_latest_top_story, -> { where.not(id: topstory.lastone) }
  scope :in_depth, -> {where.not(:type_id => [1,2,26,31,32])}
  scope :not_latest_in_depth, -> { where.not(id: in_depth.lastone) }
  scope :morning, -> {where(:urgency => 'morning')}
  scope :evening, -> {where(:urgency => 'evening')}
  scope :editorial, -> {where(:type_id => 1)}
  scope :not_latest_editorial, -> { where.not(id: editorial.lastone) }
  scope :news, -> {where(:type_id => [2,31,32])}
  scope :bignews, -> {where(:urgency => ['latest', 'breaking', 'majorbreaking'])}
  scope :breakingonly, -> {where(:urgency => ['breaking', 'majorbreaking'])}
  scope :latest, -> {order('created_at DESC').where(:created_at => (Time.now - 24.hours)..Time.now)}
  scope :ticker, -> {limit(1)}
  scope :politics, -> {joins(:categories).merge(Category.politics)}
  scope :economy, -> {joins(:categories).merge(Category.economy)}
  scope :diplomacy, -> {joins(:categories).merge(Category.diplomacy)}
  scope :published, -> {where(status: ['published', 'updated'])}
  scope :lastone, -> {order('created_at DESC').limit(1)}
  scope :lastfour, -> {order('created_at DESC').limit(4)}
  scope :lastfive, -> {order('created_at DESC').limit(5)}
  scope :lastsix, -> {order('created_at DESC').limit(6)}
  scope :lastseven, -> {order('created_at DESC').limit(7)}
  scope :lastten, -> {order('created_at DESC').limit(10)}
  scope :lasttwenty, -> {order('created_at DESC').limit(20)}
  scope :lastthirty, -> {order('created_at DESC').limit(30)}
  scope :lastfewdays, -> {where(:created_at => 7.days.ago...1.days.ago).limit(50)}
  scope :last24, -> {where(:created_at => 24.hours.ago..DateTime.now.in_time_zone)}
  scope :next24, -> {where('created_at <= ? and created_at >= now()', 24.hours.from_now).limit(20)}
  scope :following5days, -> {where('created_at <= ? and created_at >= ?', 6.days.from_now, 1.days.from_now).limit(20)}
  scope :following614days, -> {where('created_at <= ? and created_at >= ?', 14.days.from_now, 6.days.from_now).limit(20)}
  scope :upto30days, -> {where('created_at <= ? and created_at >= ?', 30.days.from_now, 14.days.from_now).limit(20)}
  
end
