class Notificationtype < ActiveRecord::Base
  scope :urgency_1, -> {where(:order => 1)}
  scope :urgency_2, -> {where(:order => 2)}
  scope :urgency_3, -> {where(:order => 3)}
  scope :urgency_4, -> {where(:order => 4)}
end
