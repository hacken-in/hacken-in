require 'carrierwave/orm/activerecord'

class Picture < ActiveRecord::Base
  attr_accessible :description, :image, :title
  mount_uploader :image, PictureUploader
   
end
