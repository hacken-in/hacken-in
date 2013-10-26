require 'carrierwave/orm/activerecord'

class Picture < ActiveRecord::Base
  mount_uploader :box_image, PictureUploader
  default_scope -> { order(:title) }
end
