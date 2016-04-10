class MigrateSlugsToRegionSlugs < ActiveRecord::Migration
  def change
    Region.all.each do |region|
      RegionSlug.where(slug: region.slug, region: region).first_or_create!
    end
  end
end
