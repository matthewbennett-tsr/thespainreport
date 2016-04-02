class Province < ActiveRecord::Base
  has_many :organisations
  has_many :sources
end
