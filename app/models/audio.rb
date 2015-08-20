class Audio < ActiveRecord::Base
  scope :lastone, -> {order('updated_at DESC').limit(1)}
  scope :lastthirty, -> {order('updated_at DESC').limit(30)}
end
