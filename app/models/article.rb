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
  
  scope :is_blog, -> {where(:type_id => 26)}
  scope :not_blog, -> {where.not(:type_id => 26)}
  scope :in_depth, -> {where(:type_id => [3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,25])}
  scope :editorial, -> {where(:type_id => 1)}
  scope :news, -> {where(:type_id => 2)}
  scope :published, -> {where(status: ['published', 'updated'])}
  scope :lastfive, -> {order('updated_at DESC').limit(5)}
  scope :lastseven, -> {order('updated_at DESC').limit(7)}
  scope :lastten, -> {order('updated_at DESC').limit(10)}
  scope :lastthirty, -> {order('updated_at DESC').limit(30)}
  scope :today, -> {where(:created_at => 1.days.ago..DateTime.now).limit(20)}
  scope :tomorrow, -> {where('created_at <= ? and created_at >= now()', 1.days.from_now).limit(20)}
  scope :restofweek, -> {where('created_at <= ? and created_at >= ?', 8.days.from_now, 1.days.from_now).limit(20)}
  scope :weekafter, -> {where('created_at <= ? and created_at >= ?', 14.days.from_now, 8.days.from_now).limit(20)}
  scope :restofmonth, -> {where('created_at <= ? and created_at >= ?', 30.days.from_now, 14.days.from_now).limit(20)}

end
