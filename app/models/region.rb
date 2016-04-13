class Region < ActiveRecord::Base
  validates_uniqueness_of :name

  has_many :region_organizers
  has_many :organizers, through: :region_organizers, source: :user
  has_many :region_slugs, dependent: :destroy

  scope :active, -> { where(active: true) }

  def to_param
    "#{id}-#{main_slug}"
  end

  def main_slug
    region_slugs.find_by(main_slug: true).try(:slug) || region_slugs.try(:first).try(:slug)
  end
end
