require 'spec_helper'

describe SingleEventExternalUser do
  it "must have a valid email address and a name" do
    single_event = FactoryBot.create(:single_event)

    expect(single_event.external_users.create(email: "hans#wurst.com", name: "Hans Wurst")).not_to be_valid
    expect(single_event.external_users.create(email: nil, name: "Hans Wurst")).not_to be_valid
    expect(single_event.external_users.create(email: "hans@wurst.com", name: nil)).not_to be_valid
    expect(single_event.external_users.create(email: "hans@wurst.com", name: "Hans Wurst")).to be_valid
  end
end
