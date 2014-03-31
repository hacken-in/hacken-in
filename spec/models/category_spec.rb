require "spec_helper"

describe Category do

  it "should generate a param with title" do
    cat = Category.create(title: "my title")
    expect(cat.to_param).to eq("#{cat.id}-my-title")
  end

  it "should find a category title for a category id" do
    cat = Category.create(title: "my title")
    expect(Category.title_for(cat.id)).to eq("my title")
  end

  it "should return 'No Category' for unknown categories" do
    expect(Category.title_for(10000)).to eq("No Category")
  end
end
