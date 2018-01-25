require 'spec_helper'

describe Region do
  let(:region) { FactoryBot.create(:koeln_region) }

  it "gets organized by users" do
    user = FactoryBot.create(:user)
    another_user = FactoryBot.create(:another_user)

    region.organizers += [user, another_user]

    expect(user.organized_regions).to match_array([region])
    expect(another_user.organized_regions).to match_array([region])
  end

  it "doesn't get assigned twice to the same user" do
    user = FactoryBot.create(:user)
    region = FactoryBot.create(:koeln_region)

    region.organizers << user
    expect { region.organizers << user }.to raise_error(ActiveRecord::RecordInvalid)
  end

  describe '#main_slug' do
    context 'main_slug present' do
      it "returns the main region slug's slug" do
        FactoryBot.create :region_slug, region: region

        expect(region.reload.main_slug).to eq 'koeln'
      end
    end

    context 'main_slug not present' do
      it "returns the 'first' region_slug" do
        other_region = FactoryBot.create :slugless_region
        FactoryBot.create :region_slug, region: other_region, main_slug: true, slug: 'oldenburg'
        FactoryBot.create :region_slug, region: other_region, main_slug: false, slug: 'bremen'

        expect(other_region.reload.main_slug).to eq other_region.region_slugs.first.slug
      end
    end
  end
end
