class Source < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :province
  has_many :quotes, dependent: :destroy
end
