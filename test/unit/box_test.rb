require 'test_helper'

class BoxTest < ActiveSupport::TestCase
  setup do
    FactoryGirl.create :box, position: 4
    FactoryGirl.create :box, position: 1
    FactoryGirl.create :box, position: nil
  end

  test "list all active boxes" do
    active_boxes = Box.active
    assert_equal 2, active_boxes.length
  end

  test "sort the active boxes" do
    active_boxes = Box.active
    assert_equal 1, active_boxes.first.position
  end

  test "every position only exists once" do
    assert_equal false, FactoryGirl.build(:box, position: 1).valid?
  end

  test "there may be as many boxes without position as you want" do
    assert FactoryGirl.build(:box, position: nil).valid?
  end

  test "first line should be the teaser text for blog posts" do
    post = FactoryGirl.build :full_blog_post
    assert_equal post.teaser_text, FactoryGirl.build(:box, content: post).first_line
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

  test "presence of first line known" do
    [:full_blog_post, :single_event].each do |type|
      content = FactoryGirl.build type
      assert FactoryGirl.build(:box, content: content).first_line?
    end

    [:full_event].each do |type|
      content = FactoryGirl.build type
      assert_equal false, FactoryGirl.build(:box, content: content).first_line?
    end
  end

  test "presence of second line known" do
    [:full_blog_post, :single_event, :full_event].each do |type|
      content = FactoryGirl.build type
      assert FactoryGirl.build(:box, content: content).second_line?
    end
  end
end
