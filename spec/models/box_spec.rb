require "spec_helper"

describe Box do
  let(:ad) { FactoryGirl.build :advertisement }
  let(:post) { FactoryGirl.build :full_blog_post }
  let(:event) { event = FactoryGirl.build :full_event }
  let(:single_event) { FactoryGirl.build :single_event }

  before :each do
    FactoryGirl.create :box, grid_position: 4,   carousel_position: 2
    FactoryGirl.create :box, grid_position: 1,   carousel_position: nil
    FactoryGirl.create :box, grid_position: nil, carousel_position: 1
  end

  it "list all active boxes" do
    Box.in_grid.should have(2).active_boxes
  end

  it "sort the active boxes" do
    Box.in_grid.map(&:grid_position).should eq [1, 4]
  end

  it "every grid position only exists once" do
    FactoryGirl.build(:box,
      grid_position: 1,
      carousel_position: 3
    ).should_not be_valid
  end

  it "there may be as many boxes without grid position as you want" do
    FactoryGirl.build(:box,
      grid_position: nil,
      carousel_position: 3
    ).should be_valid
  end

  it "there may be as many boxes without carousel position as you want" do
    FactoryGirl.build(:box,
      grid_position: 5,
      carousel_position: nil
    ).should be_valid
  end

  it "every carousel position only exists once" do
    FactoryGirl.build(:box,
      grid_position: 5,
      carousel_position: 1
    ).should_not be_valid
  end

  it "first line should be the teaser text for blog posts" do
    FactoryGirl.build(:box, content: post).first_line.should eq post.headline_teaser
  end

  it "second line should be the headline for blog posts" do
    FactoryGirl.build(:box, content: post).second_line.should eq post.headline
  end

  it "first line should be the occurrence for single events" do
    FactoryGirl.build(:box, content: single_event).first_line.should eq single_event.occurrence
  end

  it "second line should be the title for single events" do
    FactoryGirl.build(:box, content: single_event).second_line.should eq single_event.title
  end

  it "first line should be nil for events" do
    FactoryGirl.build(:box, content: event).first_line.should be_nil
  end

  it "second line should be the title for events" do
    FactoryGirl.build(:box, content: event).second_line.should eq event.title
  end

  it "first and second line should be nil for advertisement" do
    FactoryGirl.build(:box, content: ad).first_line.should be_nil
    FactoryGirl.build(:box, content: ad).second_line.should be_nil
  end

  it "presence of first line known" do
    [:full_blog_post, :single_event].each do |type|
      content = FactoryGirl.build type
      FactoryGirl.build(:box, content: content).first_line?.should be_true
    end

    [:full_event, :advertisement].each do |type|
      content = FactoryGirl.build type
      FactoryGirl.build(:box, content: content).first_line?.should be_false
    end
  end

  it "presence of second line known" do
    [:full_blog_post, :single_event, :full_event].each do |type|
      content = FactoryGirl.build type
      FactoryGirl.build(:box, content: content).second_line?.should be_true
    end

    [:advertisement].each do |type|
      content = FactoryGirl.build type
      FactoryGirl.build(:box, content: content).second_line?.should be_false
    end
  end

  it "should know that an event is not an ad" do
    FactoryGirl.build(:box, content: event).is_ad?.should be_false
  end

  it "should know that an ad is not an ad (yep)" do
    FactoryGirl.build(:box, content: ad).is_ad?.should be_true
  end

  it "an advertisement should never be placed in the carousel" do
    FactoryGirl.build(:box,
      content: ad,
      grid_position: 2,
      carousel_position: 3
    ).should_not be_valid
  end
end
