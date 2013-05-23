require "spec_helper"

describe Category do

  it "should generate a param with title" do
    cat = Category.create(title: "my title")
    cat.to_param.should == "#{cat.id}-my-title"
  end

  it "should find a category title for a category id" do
    cat = Category.create(title: "my title")
    Category.title_for(cat.id).should == "my title"
  end

  it "should return 'No Category' for unknown categories" do
    Category.title_for(10000).should == "No Category"
  end
end
