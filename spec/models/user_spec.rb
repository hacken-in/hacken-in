require 'spec_helper'

describe User do
  it "can be saved" do
    u = User.create(nickname: "bitboxer", email: "bodo@example.com", password: "mylongpassword")
    u.should be_valid
  end

  it "validates uniqueness of nickname" do
    u = User.create(nickname: "bitboxer2", email: "bodo2@example.com", password: "mylongpassword")
    u.should be_valid
    u2 = User.create(nickname: "bitboxer2", email: "bodo3@example.com", password: "mylongpassword")
    u2.should have(1).error_on(:nickname)
  end

  it "validates uniqueness of email" do
    u = User.create(nickname: "bitboxer3", email: "bodo4@example.com", password: "mylongpassword")
    u.should be_valid
    u2 = User.create(nickname: "bitboxer4", email: "bodo4@example.com", password: "mylongpassword")
    u2.should have(1).error_on(:email)
  end

  it "searches user by nickname" do
    u = User.create(nickname: "bitboxer5", email: "bodo5@example.com", password: "mylongpassword")
    User.find_for_database_authentication(email: "bitboxer5").should == u
  end

  it "searches user by email" do
    u = User.create(nickname: "bitboxer6", email: "bodo6@example.com", password: "mylongpassword")
    User.find_for_database_authentication(email: "bodo6@example.com").should == u
  end

  it "lets users participate in single event" do
    single = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:user)
    user.single_events << single
    user.save

    user.single_events.first.should == single
    user.single_events.length.should == 1
  end

  it "lets users curate events" do
    event = FactoryGirl.create(:simple)
    user = FactoryGirl.create(:user)

    user.curated_events << event

    event.curators.should =~ [user]
  end

  it "ignores tags that are not publicy viewable by default" do
    user = FactoryGirl.create(:user)
    user.should_not be_allow_ignore_view
  end

  it "doesn't change the users guid" do
    user = FactoryGirl.create(:user)
    guid = user.guid

    user.guid.should == guid
  end

  it "validates that user has a unique guid" do
    first_user = FactoryGirl.create(:user)
    second_user = FactoryGirl.create(:another_user)

    first_user.guid.should_not == second_user.guid
  end

  it "only changes user email when current password is given" do
    user = FactoryGirl.create(:user)
    user.update_with_password(email: "newexample@example.com").should be_false
    user.update_with_password(email: "newexample2@example.com", current_password: "hallo123").should be_true
    user.reload
    user.email.should == "newexample2@example.com"
  end

  it "lets users organize regions" do
    user = FactoryGirl.create(:user)
    region = FactoryGirl.create(:koeln_region)

    user.organized_regions << region

    region.organizers.should =~ [user]
  end
end

