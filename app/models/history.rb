class History < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  
  scope :firstone, -> {order('created_at ASC').limit(1)}
  scope :lastten, -> {order('updated_at DESC').limit(10)}
end
