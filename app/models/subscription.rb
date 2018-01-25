class Subscription < ActiveRecord::Base
  belongs_to :user
  
  scope :active, -> {where(:stripe_status => ['active'])}
  
end
