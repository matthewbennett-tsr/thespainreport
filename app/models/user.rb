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
  
  before_create :confirmation_token
  before_create :set_default_role
  before_create :set_default_emailpref

  ROLES = %i[editor subscriber reader]
  
  scope :subscribers, -> {where(role: 'subscriber')}
  scope :activesubscribers, -> {where.not(stripe_customer_id: '')}
  scope :straysubscribers, -> {where(role: 'subscriber').where('stripe_customer_id is null')}
  scope :readers, -> {where(role: 'reader')}
  scope :editors, -> {where(role: 'editor')}
  scope :wantssummariesbreaking, -> {where(emailpref: ['articlesupdates', 'justarticles', 'justsummariesbreaking'])}
  scope :wantsarticles, -> {where(emailpref: ['articlesupdates', 'justarticles'])}
  scope :wantsupdates, -> {where(emailpref: 'articlesupdates')}
  scope :lasttenusers, -> {order('created_at DESC').limit(10)}
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
  
  has_many :comments
  
  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[@#!$%&+=])(?=.*[\s])./)
      errors.add :password, ": must include at least a lowercase letter, a capital letter, a number, a space and one of these symbols: ! @ # $ % & + ="
    end
  end
  
  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
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
  
  private
  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
  
  def set_default_role
    self.role ||= 'reader'
  end
  
  def set_default_emailpref
    self.emailpref ||= 'articlesupdates'
  end
  
end
