require "spec_helper"

describe Advertisement do
  it "find only advertisement with the right context for the homepage" do
    advertisement1 = FactoryGirl.create :advertisement, context: "blog_post"
    advertisement2 = FactoryGirl.create :advertisement, context: "homepage"
    Advertisement.homepage.should eq advertisement2
  end

  it "find the advertisement starting this week for the homepage" do
    advertisement1 = FactoryGirl.create :advertisement,
                                        context: "homepage",
                                        calendar_week: (DateTime.now + 2.weeks).iso_cweek
    advertisement2 = FactoryGirl.create :advertisement,
                                        context: "homepage",
                                        calendar_week: DateTime.now.iso_cweek
    Advertisement.homepage.should eq advertisement2
  end

  it "find the advertisement that spans for more than one week" do
    advertisement = FactoryGirl.create :advertisement,
                                       context: "homepage",
                                       calendar_week: (DateTime.now - 1.week).iso_cweek,
                                       duration: 3
    Advertisement.homepage.should eq advertisement
  end
end
