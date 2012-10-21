require 'carrierwave/orm/activerecord'

class Picture < ActiveRecord::Base
  attr_accessible :description, :box_image, :carousel_image, :title
  mount_uploader :box_image, PictureUploader
  mount_uploader :carousel_image, CarouselUploader
  default_scope order(:title)
end
