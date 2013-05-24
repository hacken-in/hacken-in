require 'spec_helper'

describe Tag do

  it "should generate to_param with name" do
    Tag.create(name: "tag name").to_param.should == "tag-name"
  end

end
