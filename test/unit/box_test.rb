require 'test_helper'

class BoxTest < ActiveSupport::TestCase
  setup do
    FactoryGirl.create :box, grid_position: 4,   carousel_position: 2
    FactoryGirl.create :box, grid_position: 1,   carousel_position: nil
    FactoryGirl.create :box, grid_position: nil, carousel_position: 1
  end

  test "list all active boxes" do
    active_boxes = Box.in_grid
    assert_equal 2, active_boxes.length
  end

  test "sort the active boxes" do
    active_boxes = Box.in_grid
    assert_equal 1, active_boxes.first.grid_position
  end

  test "every grid position only exists once" do
    assert_equal false, FactoryGirl.build(:box,
      grid_position: 1,
      carousel_position: 3
    ).valid?
  end

  test "there may be as many boxes without grid position as you want" do
    assert FactoryGirl.build(:box,
      grid_position: nil,
      carousel_position: 3
    ).valid?
  end

  test "there may be as many boxes without carousel position as you want" do
    assert FactoryGirl.build(:box,
      grid_position: 5,
      carousel_position: nil
    ).valid?
  end

  test "every carousel position only exists once" do
    assert_equal false, FactoryGirl.build(:box,
      grid_position: 5,
      carousel_position: 1
    ).valid?
  end

  test "first line should be the teaser text for blog posts" do
    post = FactoryGirl.build :full_blog_post
    assert_equal post.headline_teaser, FactoryGirl.build(:box, content: post).first_line
  end

  test "second line should be the headline for blog posts" do
    post = FactoryGirl.build :full_blog_post
    assert_equal post.headline, FactoryGirl.build(:box, content: post).second_line
  end

  test "first line should be the occurrence for single events" do
    single_event = FactoryGirl.build :single_event
    assert_equal single_event.occurrence, FactoryGirl.build(:box, content: single_event).first_line
  end

  test "second line should be the title for single events" do
    single_event = FactoryGirl.build :single_event
    assert_equal single_event.title, FactoryGirl.build(:box, content: single_event).second_line
  end

  test "first line should be nil for events" do
    event = FactoryGirl.build :full_event
    assert_nil FactoryGirl.build(:box, content: event).first_line
  end

  test "second line should be the title for events" do
    event = FactoryGirl.build :full_event
    assert_equal event.title, FactoryGirl.build(:box, content: event).second_line
  end

  test "first and second line should be nil for advertisement" do
    ad = FactoryGirl.build :advertisement
    assert_nil FactoryGirl.build(:box, content: ad).first_line
    assert_nil FactoryGirl.build(:box, content: ad).second_line
  end

  test "presence of first line known" do
    [:full_blog_post, :single_event].each do |type|
      content = FactoryGirl.build type
      assert FactoryGirl.build(:box, content: content).first_line?
    end

    [:full_event, :advertisement].each do |type|
      content = FactoryGirl.build type
      assert_equal false, FactoryGirl.build(:box, content: content).first_line?
    end
  end

  test "presence of second line known" do
    [:full_blog_post, :single_event, :full_event].each do |type|
      content = FactoryGirl.build type
      assert FactoryGirl.build(:box, content: content).second_line?
    end

    [:advertisement].each do |type|
      content = FactoryGirl.build type
      assert_equal false, FactoryGirl.build(:box, content: content).second_line?
    end
  end

  test "should know that an event is not an ad" do
    event = FactoryGirl.build :full_event
    assert_equal false, FactoryGirl.build(:box, content: event).is_ad?
  end

  test "should know that an ad is not an ad (yep)" do
    ad = FactoryGirl.build :advertisement
    assert FactoryGirl.build(:box, content: ad).is_ad?
  end

  test "an advertisement should never be placed in the carousel" do
    ad = FactoryGirl.build :advertisement
    assert_equal false, FactoryGirl.build(:box,
      content: ad,
      grid_position: 2,
      carousel_position: 3
    ).valid?
  end
end
