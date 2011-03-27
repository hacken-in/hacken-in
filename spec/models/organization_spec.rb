require 'spec_helper'

describe Organization do

  it "can be instantiated" do
    Organization.new.should be_an_instance_of(Organization)
  end

  it "can be saved successfully" do
    Organization.create.should be_persisted
  end

  it "has a name and a description" do
    org = Organization.create(:name => "HallO", :description=>"Very long description is needed")
    
    newOrg = Organization.find(org.id)
    newOrg.name.should == "HallO"
    newOrg.description.should == "Very long description is needed"
  end

end
