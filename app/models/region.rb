class Region < ActiveRecord::Base
  has_and_belongs_to_many :newsitems
  has_and_belongs_to_many :articles
  
  def to_param
  "#{id}-#{region.parameterize}"
  end
end
