class CreateDefaultRegions < ActiveRecord::Migration
  def up
    Region.create(name: 'Global', slug: 'global', perimeter: nil) { |region| region.id = 1 }
    Region.create(name: 'Köln', slug: 'koeln', latitude: 50.946025641, longitude: 6.958888889, perimeter: 20) { |region| region.id = 2 }
    Region.create(name: 'Berlin', slug: 'berlin', latitude: 52.518611, longitude: 13.408056, perimeter: 20) { |region| region.id = 3 }
  end

  def down
    Region.where(slug: %w(koeln berlin global)).destroy_all
  end
end
