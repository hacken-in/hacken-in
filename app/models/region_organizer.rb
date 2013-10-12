class RegionOrganizer < ActiveRecord::Base
  belongs_to :region
  belongs_to :user
  attr_accessible :region

  validates_uniqueness_of :region_id, :scope => :user_id
end
