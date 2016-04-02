class Source < ActiveRecord::Base
  belongs_to :organisation
  has_many :quotes, dependent: :destroy
end
