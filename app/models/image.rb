class Image < ActiveRecord::Base

  mount_uploader :url, ImageUploader

end
