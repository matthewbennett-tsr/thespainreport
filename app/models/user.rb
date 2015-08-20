class User < ActiveRecord::Base
  has_secure_password
  validates :email, :uniqueness => {:case_sensitive => false}
  validates_format_of :email, :with => /@/, message: ": are you sure that's your e-mail address?"
  validates :password, :on => :create, length: {minimum: 11, message: ": needs to be at least 11 characters long"}
  validates :password, :on => :update, length: {minimum: 11, message: ": needs to be at least 11 characters long"}, allow_blank: true
  validates :name, :on => :update, :uniqueness => {:case_sensitive => false}, length: {maximum: 20}
  validate :password_complexity
  validates :password_confirmation, :presence => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :update, allow_blank: true
  
  before_create :confirmation_token
  before_create :set_default_role

  ROLES = %i[editor subscriber reader]
  scope :subscribers, -> {where(role: 'subscriber')}
  scope :readers, -> {where(role: 'reader')}
  
  has_many :comments
  
  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[@#$%&+=])(?=.*[\s])./)
      errors.add :password, ": must include at least one of each: lowercase letter, capital letter, number, symbol (@#$%&+=), space."
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
  save!
  UserMailer.password_reset(self).deliver
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
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
  
end
