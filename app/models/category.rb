class Category < ActiveRecord::Base
  has_and_belongs_to_many :newsitems
  has_and_belongs_to_many :articles
  
  def to_param
  "#{id}-spain-#{category.parameterize}"
  end
end
