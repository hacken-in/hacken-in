require 'spec_helper'

describe User do
  it "can be instantiated" do
    User.new.should be_an_instance_of(User)
  end

  it "can be saved successfully" do
    u = User.create(:email => "bodo@example.com", :password => "mylongpassword").should be_persisted
  end

end
