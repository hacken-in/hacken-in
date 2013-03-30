# encoding: utf-8
require 'spec_helper'

describe UserEditObserver do
  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it "should send mail for new comment" do
    simple = FactoryGirl.create(:simple)
    ActionMailer::Base.deliveries.clear
    simple.comments.create(body: "ein test body")

    ActionMailer::Base.deliveries.should_not be_empty
  end

  it "should send mail for updated comment" do
    comment = FactoryGirl.create(:single_event_comment)
    comment.body = "new body"
    comment.save

    ActionMailer::Base.deliveries.should_not be_empty
  end

end
