require 'spec_helper'

describe Organization do

  it "can be instantiated" do
    Organization.new.should be_an_instance_of(Organization)
  end

  it "can be saved successfully" do
    Organization.create.should be_persisted
  end

end
