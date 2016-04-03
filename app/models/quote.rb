class Quote < ActiveRecord::Base
  belongs_to :source
  
  TYPES = %i[phone email facebook twitter]
end
