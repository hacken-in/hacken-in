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
    u2.error_on(:nickname).length.should be 1
  end

  it "validates uniqueness of email" do
    u = User.create(nickname: "bitboxer3", email: "bodo4@example.com", password: "mylongpassword")
    u.should be_valid
    u2 = User.create(nickname: "bitboxer4", email: "bodo4@example.com", password: "mylongpassword")
    u2.should_not be_valid
    expect(u2.error_on(:email)).not_to be_empty
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
    user.update_with_password(email: "newexample@example.com").should be_falsey
    user.update_with_password(email: "newexample2@example.com", current_password: "hallo123").should be_truthy
    user.reload
    user.email.should == "newexample2@example.com"
  end

  context "organizing regions" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:admin) { FactoryGirl.create(:bodo) }
    let!(:koeln_region) { FactoryGirl.create(:koeln_region) }
    let!(:berlin_region) { FactoryGirl.create(:berlin_region) }

    it "lets users organize regions" do
      user.assigned_regions << koeln_region

      koeln_region.organizers.should =~ [user]
    end

    it "should list all regions as organized by an admin" do
      admin.organized_regions.should =~ [koeln_region, berlin_region]
    end

    it "should only list assigned regions for a normal user" do
      user.organized_regions.should == []

      user.assigned_regions << berlin_region

      user.organized_regions.should =~ [berlin_region]
    end
  end

  context "fixes user input URLs" do
    it "should not fix twitter handle if it okay" do
      user = FactoryGirl.create(:user)
      user.twitter = "twitterhandle"
      user.save
      user.twitter.should == "twitterhandle"
    end

    it "should try to fix twitter handle if it starts with twitter.com/" do
      user = FactoryGirl.create(:user)
      user.twitter = "twitter.com/twitterhandle"
      user.save
      user.twitter.should == "twitterhandle"
    end

    it "should try to fix twitter handle if it starts with http://twitter.com/" do
      user = FactoryGirl.create(:user)
      user.twitter = "http://twitter.com/twitterhandle"
      user.save
      user.twitter.should == "twitterhandle"
    end

    it "should try to fix twitter handle if it starts with httpS://twitter.com/" do
      user = FactoryGirl.create(:user)
      user.twitter = "https://twitter.com/twitterhandle"
      user.save
      user.twitter.should == "twitterhandle"
    end

    it "should not try to fix github handle if it is okay" do
      user = FactoryGirl.create(:user)
      user.github = "githubhandle"
      user.save
      user.github.should == "githubhandle"
    end

    it "should try to fix github handle if it starts with github.com/" do
      user = FactoryGirl.create(:user)
      user.github = "github.com/githubhandle"
      user.save
      user.github.should == "githubhandle"
    end

    it "should try to fix github handle if it starts with http://github.com/" do
      user = FactoryGirl.create(:user)
      user.github = "http://github.com/githubhandle"
      user.save
      user.github.should == "githubhandle"
    end

    it "should try to fix github handle if it starts with httpS://github.com/" do
      user = FactoryGirl.create(:user)
      user.github = "https://github.com/githubhandle"
      user.save
      user.github.should == "githubhandle"
    end

    it "should add http:// if it is missing" do
      user = FactoryGirl.create(:user)
      user.homepage = "heise.de"
      user.save
      user.homepage.should == "http://heise.de"
    end

    it "should not add http:// if it is not missing" do
      user = FactoryGirl.create(:user)
      user.homepage = "http://heise.de"
      user.save
      user.homepage.should == "http://heise.de"
    end

    it "should not add http:// if it is a https link" do
      user = FactoryGirl.create(:user)
      user.homepage = "https://heise.de"
      user.save
      user.homepage.should == "https://heise.de"
    end
  end

  it "should generate a guid if it is not present yet" do
    user = User.create
    user.guid.length.should == 17
  end

  it "should not generate a new guid if one is present" do
    user = User.create
    guid = user.guid
    user.guid.should == guid
  end

  it "should return nickname as string" do
    user = User.create(nickname: "hansdampf")
    user.to_s.should == "hansdampf"
  end

  it "should return nickname for param" do
    user = User.create(nickname: "hansdampf")
    user.to_param.should == "hansdampf"
  end

  it "should return the current user that is attached to the thread" do
    user = User.create
    User.current = user
    User.current.should == user
  end
end

