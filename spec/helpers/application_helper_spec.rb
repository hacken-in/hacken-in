#encoding: utf-8
require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  include GravatarImageTag

  it "should convert markdown" do
    markdown_formatted_text = "I am *italic* and **bold**."
    convert_markdown(markdown_formatted_text).should == "<p>I am <em>italic</em> and <strong>bold</strong>.</p>\n"
  end

  it "should strip evil javascript" do
    text_with_arbitrary_html = "<script>I am so evil</script>"
    convert_markdown(text_with_arbitrary_html).should_not =~ /<script>/
  end

  it "should convert text with emoji" do
    mtext = "I am *italic* :smile:"
    convert_markdown(mtext).should == "<p>I am <em>italic</em> <img src=\"/assets/emojis/smile.png\" class=\"emoji\" title=\":smile:\" alt=\":smile:\" height=\"20\" width=\"20\"></p>\n"
  end

  it "should convert markdown links" do
    markdown_formatted_text = "Let me [google](http://www.google.de) that for you"

    convert_markdown(markdown_formatted_text).should == "<p>Let me <a href=\"http://www.google.de\">google</a> that for you</p>\n"
    convert_markdown(markdown_formatted_text, true).should == "<p>Let me <a href=\"http://www.google.de\" rel=\"nofollow\">google</a> that for you</p>\n"
  end

  it "should return an empty list for events withoud links" do
    event = Event.new(name: "Hallo")
    collect_links(event).length.should == 0
  end

  it "should return the example url" do
    event = Event.new(name: "Hallo")
    event.url = "http://example.com"
    collect_links(event).should == [{title: "http://example.com", url: "http://example.com"}]
  end

  it "should return the twitter url" do
    event = Event.new(name: "Hallo")
    event.url = "http://example.com"
    event.twitter = "twitter"
    collect_links(event).should == [{title: "http://example.com", url: "http://example.com"},
                  {title: "@twitter", url: "http://twitter.com/twitter"}]
  end

  it "should return the hashtag" do
    event = Event.new(name: "Hallo")
    event.url = "http://example.com"
    event.twitter = "twitter"
    event.twitter_hashtag = "hashtag"
    collect_links(event).should == [{title: "http://example.com", url: "http://example.com"},
                  {title: "@twitter", url: "http://twitter.com/twitter"},
                  {title: "#hashtag", url: "https://twitter.com/search/%23hashtag"}]
  end

  it "should return the link to a single event" do
    single = FactoryGirl.create(:single_event)
    single.event.url = "http://example.com"
    single.event.twitter_hashtag = "hashtag"
    single.event.twitter_hashtag = "hashtag"
    collect_links(single).should == [{url: "http://example.com", title: "http://example.com"},
                  {url: "https://twitter.com/search/%23hashtag", title: "#hashtag"}]
  end

  it "should generate an image tag for user with an image url attached" do
    user = User.create(nickname: "hansdampf", image_url: "http://example.com/logo.png")
    avatar_for_user(user, 20, "userimage").should ==
      "<img alt=\"hansdampf\" class=\"userimage\" src=\"http://example.com/logo.png\" title=\"hansdampf\" width=\"20\" />"
  end

  it "should generate an image for a user with the default gravatar image" do
    user = User.create(nickname: "hansdampf", email: "mail@example.com")
    avatar_for_user(user, 20, "userimage").should ==
      "<img alt=\"hansdampf\" class=\"userimage\" height=\"20\" src=\"http://gravatar.com/avatar/7daf6c79d4802916d83f6266e24850af?default=identicon&size=20\" title=\"hansdampf\" width=\"20\" />"
  end

  it "should generate an image for a user with a separate gravatar image email" do
    user = User.create(nickname: "hansdampf", email: "mail@example.com",
                       image_url: "http://example.com/logo.png",
                       gravatar_email: "gravatar@example.com")
    avatar_for_user(user, 20, "userimage").should ==
      "<img alt=\"hansdampf\" class=\"userimage\" height=\"20\" src=\"http://gravatar.com/avatar/0cef130e32e054dd516c99e5181d30c4?default=identicon&size=20\" title=\"hansdampf\" width=\"20\" />"
  end

  it "should generate a string for a monthly rule" do
     string_for_rule(IceCube::Rule.monthly.day_of_week({monday: [1]})).should == "An jedem 1. #{I18n.t("date.day_names")[1]} des Monats"
  end

  it "should generate a string for a monthly rule for the last day of the month" do
     string_for_rule(IceCube::Rule.monthly.day_of_week({monday: [-1]})).should == "An jedem letzten #{I18n.t("date.day_names")[1]} des Monats"
  end

  it "should generate a string for a weekly rule" do
     string_for_rule(IceCube::Rule.weekly(1).day(:monday)).should == "An jedem  #{I18n.t("date.day_names")[1]}"
  end

  it "should generate a string for a biweekly rule" do
     string_for_rule(IceCube::Rule.weekly(2).day(:sunday)).should == "An jedem 2. #{I18n.t("date.day_names")[0]}"
  end
end
