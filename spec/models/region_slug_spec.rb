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

  it 'validates uniqueness of main_slug=true per region' do
    region = FactoryGirl.create(:slugless_region)
    RegionSlug.create(slug: 'oldenburg', region: region, main_slug: true)
    RegionSlug.create(slug: 'weser-ems', region: region, main_slug: false)
    other_main_region_slug = RegionSlug.new(slug: 'bremen', region: region, main_slug: true)

    expect(other_main_region_slug.valid?).to eq false
    expect(other_main_region_slug.errors.messages[:main_slug][0]).to eq 'ist bereits vergeben'
  end
end
