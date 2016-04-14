class RegionSlug < ActiveRecord::Base
  belongs_to :region

  validates_presence_of :region, :slug
  validates_uniqueness_of :slug
  validates_uniqueness_of :main_slug, scope: :region, if: :main_slug?
end
