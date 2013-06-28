require 'spec_helper'

describe Region do
  it "gets organized by users" do
    user = FactoryGirl.create(:user)
    another_user = FactoryGirl.create(:another_user)
    region = FactoryGirl.create(:koeln_region)

    region.organizers += [user, another_user]

    user.organized_regions.should =~ [region]
    another_user.organized_regions.should =~ [region]
  end

  it "doesn't get assigned twice to the same user" do
    user = FactoryGirl.create(:user)
    region = FactoryGirl.create(:koeln_region)

    region.organizers << user
    expect { region.organizers << user }.to raise_error(ActiveRecord::RecordInvalid)


  end

end
