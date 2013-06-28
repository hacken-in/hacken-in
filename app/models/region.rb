class Region < ActiveRecord::Base
  validates_uniqueness_of :slug
  validates_uniqueness_of :name

  has_many :region_organizers
  has_many :organizers, :through => :region_organizers, :source => :user
end
