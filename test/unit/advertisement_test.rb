require 'test_helper'

class AdvertisementTest < ActiveSupport::TestCase
  test "find only advertisement with the right context for the homepage" do
    FactoryGirl.create :advertisement, context: "blog_post", description: "not me"
    FactoryGirl.create :advertisement, context: "homepage", description: "but me"
    ad = Advertisement.homepage

    assert_equal "but me", ad.description
  end

  test "find the advertisement starting this week for the homepage" do
    FactoryGirl.create :advertisement,
      context: "homepage",
      description: "not me",
      calendar_week: (DateTime.now + 2.weeks).iso_cweek
    FactoryGirl.create :advertisement,
      context: "homepage",
      description: "but me",
      calendar_week: DateTime.now.iso_cweek
    ad = Advertisement.homepage

    assert_equal "but me", ad.description
  end
end
