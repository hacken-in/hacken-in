require 'spec_helper'

describe SingleEventExternalUser do
  it "must have a valid email address and a name" do
    single_event = FactoryGirl.create(:single_event)

    single_event.external_users.create(email: "hans#wurst.com", name: "Hans Wurst").should_not be_valid
    single_event.external_users.create(email: nil, name: "Hans Wurst").should_not be_valid
    single_event.external_users.create(email: "hans@wurst.com", name: nil).should_not be_valid
    single_event.external_users.create(email: "hans@wurst.com", name: "Hans Wurst").should be_valid
  end
end
