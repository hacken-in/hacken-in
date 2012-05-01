require 'test_helper'

class CommentsPathHelperTest < ActionView::TestCase
  include CommentsPathHelper

  test "get edit comment path" do
    assert_equal "/events/1-simpleevent/dates/1/comments/1/edit", edit_comment_path(FactoryGirl.create(:single_event).comments.create)
    assert_equal "/events/2-simpleevent/comments/2/edit", edit_comment_path(FactoryGirl.create(:simple).comments.create)
  end

  test "comment path" do
    assert_equal "/events/1-simpleevent/dates/1/comments/1", comment_path(FactoryGirl.create(:single_event).comments.create)
    assert_equal "/events/2-simpleevent/comments/2", comment_path(FactoryGirl.create(:simple).comments.create)
  end

  test "comments path" do
    assert_equal "/events/1-simpleevent/dates/1/comments", comments_path(FactoryGirl.create(:single_event).comments.create)
    assert_equal "/events/2-simpleevent/comments", comments_path(FactoryGirl.create(:simple).comments.create)
  end

  test "commentable path" do
    assert_equal "/events/1-simpleevent/dates/1", commentable_path(FactoryGirl.create(:single_event).comments.create)
    assert_equal "/events/2-simpleevent", commentable_path(FactoryGirl.create(:simple).comments.create)
  end

end
