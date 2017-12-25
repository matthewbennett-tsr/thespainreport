class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  belongs_to :notificationtype
  
  scope :level_1, -> {joins(:notificationtype).merge(Notificationtype.urgency_1)}
  scope :level_2, -> {joins(:notificationtype).merge(Notificationtype.urgency_2)}
  scope :level_3, -> {joins(:notificationtype).merge(Notificationtype.urgency_3)}
  scope :level_4, -> {joins(:notificationtype).merge(Notificationtype.urgency_4)}
  
  before_save :check_update_token
  
  def check_update_token
    if self.update_token.blank?
      self.update_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end