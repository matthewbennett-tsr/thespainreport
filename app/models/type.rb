class Type < ActiveRecord::Base
  has_many :articles
  
  def to_param
  "#{id}-spain-#{name.parameterize}"
  end
end
