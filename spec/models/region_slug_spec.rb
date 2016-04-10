require 'spec_helper'

RSpec.describe RegionSlug, type: :model do
  it 'validates presence of a region' do
    region_slug = RegionSlug.new(slug: 'noregion', region: nil)
    expect(region_slug.valid?).to eq false
  end

  it 'validates presence of a slug' do
    region = FactoryGirl.create(:slugless_region)
    region_slug = RegionSlug.new(slug: nil, region: region)
    expect(region_slug.valid?).to eq false
  end
end
