class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  scope :lastthirty, -> {order('updated_at DESC').limit(30)}
end
