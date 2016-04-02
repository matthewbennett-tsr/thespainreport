class Organisation < ActiveRecord::Base
  has_many :sources
  belongs_to :province
end
