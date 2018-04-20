class Category < ActiveRecord::Base
  has_and_belongs_to_many :newsitems
  has_and_belongs_to_many :articles
  
  def to_param
  "#{id}-spain-#{category.parameterize}"
  end
  
  def self.search(search)
    where("category @@ ?", search)
  end
  
  scope :politics, -> {where(:id => 1)}
  scope :economy, -> {where(:id => 2)}
  scope :diplomacy, -> {where(:id => 9)}
end
