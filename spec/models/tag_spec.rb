require 'spec_helper'

describe Tag do

  it "should generate to_param with name" do
    expect(Tag.create(name: "tag name").to_param).to eq("tag-name")
  end

end
