class User < ActiveRecord::Base
  has_secure_password
  validates :email, :uniqueness => {:case_sensitive => false}
  validates_format_of :email, :with => /@/, message: ": are you sure that's your e-mail address?"
  validates :password, :on => :create, length: {minimum: 11, message: ": needs to be at least 11 characters long"}
  validates :password, :on => :update, length: {minimum: 11, message: ": needs to be at least 11 characters long"}, allow_blank: true
  validates :name, :on => :update, :uniqueness => {:case_sensitive => false}, length: {maximum: 20}, allow_blank: true
  validate :password_complexity
  validates :password_confirmation, :presence => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :update, allow_blank: true
  
  before_update :check_one_story_date
  before_save :check_update_token
  
  ROLES = %i[subscriber_all_stories subscriber_all_current subscriber_one_story subscriber subscriber_paused subscriber_cancelled reader guest deleted editor staff]
  
  def self.search(search)
    where("email @@ ?", search)
  end
  
  scope :subscribers, -> {where(role: ['subscriber', 'subscriber_one_story', 'subscriber_all_current', 'subscriber_all_stories'])}
  scope :fullaccess, -> {where(role: ['subscriber', 'subscriber_all_current', 'subscriber_all_stories'])}
  scope :onestorysubscribers, -> {where(role: 'subscriber_one_story')}
  scope :allstorysubscribers, -> {where(role: 'subscriber_all_stories')}
  scope :allcurrentsubscribers, -> {where(role: 'subscriber_all_current')}
  scope :pre2018, -> {where(role: 'subscriber')}
  scope :pausedsubscribers, -> {where(role: 'subscriber_paused')}
  scope :cancelledsubscribers, -> {where(role: 'subscriber_cancelled')}
  scope :nostripeid, -> {where(role: ['subscriber', 'subscriber_one_story', 'subscriber_all_stories']).where('stripe_customer_id is null')}
  scope :totalreaders, -> {where(role: ['reader', 'guest'])}
  scope :readers, -> {where(role: 'reader')}
  scope :guests, -> {where(role: 'guest')}
  scope :editors, -> {where(role: 'editor')}
  scope :deleted, -> {where(role: 'deleted')}
  scope :active, -> {where.not(role: ['deleted', 'subscriber_cancelled'])}
  scope :dateblank, -> {where(access_date: nil)}
  scope :wantssummariesbreaking, -> {where(emailpref: ['articlesupdates', 'justarticles', 'justsummariesbreaking'])}
  scope :wantsemails, -> {where(emailpref: ['articlesupdates', 'justarticles'])}
  scope :wantsupdates, -> {where(emailpref: 'articlesupdates')}
  scope :lastfew, -> {order('created_at DESC').limit(10)}
  scope :oneday, -> {where('created_at <= ? and created_at >= ?', 0.hours.ago, 24.hours.ago)}
  scope :twodays, -> {where('created_at <= ? and created_at >= ?', 24.hours.ago, 48.hours.ago)}
  scope :threedays, -> {where('created_at <= ? and created_at >= ?', 48.hours.ago, 72.hours.ago)}
  scope :fourdays, -> {where('created_at <= ? and created_at >= ?', 72.hours.ago, 96.hours.ago)}
  scope :fivedays, -> {where('created_at <= ? and created_at >= ?', 96.hours.ago, 120.hours.ago)}
  scope :sixdays, -> {where('created_at <= ? and created_at >= ?', 120.hours.ago, 144.hours.ago)}
  scope :sevendays, -> {where('created_at <= ? and created_at >= ?', 144.hours.ago, 168.hours.ago)}
  scope :eightdays, -> {where('created_at <= ? and created_at >= ?', 168.hours.ago, 192.hours.ago)}
  scope :ninedays, -> {where('created_at <= ? and created_at >= ?', 192.hours.ago, 216.hours.ago)}
  scope :tendays, -> {where('created_at <= ? and created_at >= ?', 216.hours.ago, 240.hours.ago)}
  scope :elevendays, -> {where('created_at <= ? and created_at >= ?', 240.hours.ago, 264.hours.ago)}
  scope :twelvedays, -> {where('created_at <= ? and created_at >= ?', 264.hours.ago, 288.hours.ago)}
  scope :thirteendays, -> {where('created_at <= ? and created_at >= ?', 288.hours.ago, 312.hours.ago)}
  scope :fourteendays, -> {where('created_at <= ? and created_at >= ?', 312.hours.ago, 336.hours.ago)}
  scope :fifteendays, -> {where('created_at <= ? and created_at >= ?', 336.hours.ago, 360.hours.ago)}
  scope :sixteendays, -> {where('created_at <= ? and created_at >= ?', 360.hours.ago, 384.hours.ago)}
  scope :seventeendays, -> {where('created_at <= ? and created_at >= ?', 384.hours.ago, 408.hours.ago)}
  scope :eighteendays, -> {where('created_at <= ? and created_at >= ?', 408.hours.ago, 432.hours.ago)}
  scope :nineteendays, -> {where('created_at <= ? and created_at >= ?', 432.hours.ago, 456.hours.ago)}
  scope :twentydays, -> {where('created_at <= ? and created_at >= ?', 456.hours.ago, 480.hours.ago)}
  scope :twentyonedays, -> {where('created_at <= ? and created_at >= ?', 480.hours.ago, 504.hours.ago)}
  scope :thirtydays, -> {where('created_at <= ? and created_at >= ?', 720.hours.ago, 744.hours.ago)}
  scope :trial, -> {where('created_at <= ? and created_at >= ?', 0.hours.ago, 744.hours.ago)}
  scope :aftertrial, -> {where('created_at <= ?', 744.hours.ago)}
  scope :user_level_1, -> {joins(:notifications).merge(Notification.level_1)}
  scope :frequency_2, -> {where(briefing_frequency: 2)}
  scope :frequency_3, -> {where(briefing_frequency: 3)}
  scope :frequency_6, -> {where(briefing_frequency: 6)}
  scope :frequency_12, -> {where(briefing_frequency: 12)}
  scope :frequency_24, -> {where(briefing_frequency: 24)}
  scope :frequency_84, -> {where(briefing_frequency: 84)}
  scope :frequency_168, -> {where(briefing_frequency: 168)}
  
  has_many :comments
  has_many :subscriptions
  has_many :invoices
  has_many :histories
  has_many :articles, :through => :histories
  has_many :notifications, -> {joins(:story).order("story ASC")}, dependent: :destroy
  has_many :stories, :through => :notifications
  accepts_nested_attributes_for :notifications
  belongs_to :briefing_frequency
  belongs_to :account
  
  def password_complexity
    if password.present? and not password.match(/^(?=.*[A-Z])./) and not password.match(/^(?=.*[\s])./)
      errors.add :password, ": must include at least one capital letter and one space"
    elsif password.present? and not password.match(/^(?=.*[\s])./)
      errors.add :password, ": must include at least one space"
    elsif password.present? and not password.match(/^(?=.*[A-Z])./)
      errors.add :password, ": must include at least one capital letter"
    end
  end
  
  def email_activate
    self.email_confirmed = true
    save!(:validate => false)
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save!(:validate => false)
  UserMailer.delay.password_reset(self)
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.delay.password_reset(self)
  end
  
  def check_update_token
    if self.update_token.blank?
      self.update_token = SecureRandom.urlsafe_base64.to_s
    end
  end
  
  private
  def check_one_story_date
    if self.one_story_id_changed?
      self.one_story_date = Time.now
    else
    end
  end
  
  
  
end
