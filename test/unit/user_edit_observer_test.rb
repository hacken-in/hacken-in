# encoding: utf-8
require 'test_helper'

class UserEditObserverTest < ActiveSupport::TestCase
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "Send mail for new comment" do
    simple = FactoryGirl.create(:simple)
    ActionMailer::Base.deliveries.clear
    simple.comments.create(body: "ein test body")
    assert !ActionMailer::Base.deliveries.empty?
  end

  test "Send mail for updated comment" do
    comment = FactoryGirl.create(:single_event_comment)
    comment.body = "new body"
    comment.save
    assert !ActionMailer::Base.deliveries.empty?
  end

end
