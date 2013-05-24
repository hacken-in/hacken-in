#encoding: utf-8
require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  include GravatarImageTag

  it "should check if output for today is correct" do
    today = Date.today
    retval = <<-EOL
        <div class='calendar-datebox-d'>
          #{today.strftime('%d')}
        </div>
        <div class='calendar-datebox-box'>
          <div class='calendar-datebox-my'>#{I18n.localize(today, format: '%b %Y')}</div>
          <div class='calendar-datebox-wd'>#{I18n.localize(today, format: '%A')}</div>
        </div> - Heute
      EOL
    day_output_helper(today).should == retval
  end

  it "should check if output for tomorrow is correct" do
    tomorrow = Date.today+1
    retval = <<-EOL
        <div class='calendar-datebox-d'>
          #{tomorrow.strftime('%d')}
        </div>
        <div class='calendar-datebox-box'>
          <div class='calendar-datebox-my'>#{I18n.localize(tomorrow, format: '%b %Y')}</div>
          <div class='calendar-datebox-wd'>#{I18n.localize(tomorrow, format: '%A')}</div>
        </div> - Morgen
      EOL
    day_output_helper(tomorrow).should == retval
  end

  it "should check if output for day after tomorrow is correct" do
    day_after_tomorrow = Date.today+2
    retval = <<-EOL
        <div class='calendar-datebox-d'>
          #{day_after_tomorrow.strftime('%d')}
        </div>
        <div class='calendar-datebox-box'>
          <div class='calendar-datebox-my'>#{I18n.localize(day_after_tomorrow, format: '%b %Y')}</div>
          <div class='calendar-datebox-wd'>#{I18n.localize(day_after_tomorrow, format: '%A')}</div>
        </div> - Übermorgen
      EOL
    day_output_helper(day_after_tomorrow).should == retval
  end

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
      "<img alt=\"hansdampf\" class=\"userimage\" src=\"http://example.com/logo.png\" width=\"20\" />"
  end

  it "should generate an image for a user with the default gravatar image" do
    user = User.create(nickname: "hansdampf", email: "mail@example.com")
    avatar_for_user(user, 20, "userimage").should == 
      "<img alt=\"Gravatar\" class=\"userimage\" height=\"20\" src=\"http://gravatar.com/avatar/7daf6c79d4802916d83f6266e24850af?default=identicon&amp;size=20\" width=\"20\" />"
  end

  it "should generate an image for a user with a separate gravatar image email" do
    user = User.create(nickname: "hansdampf", email: "mail@example.com", 
                       gravatar_email: "gravatar@example.com")
    avatar_for_user(user, 20, "userimage").should == 
      "<img alt=\"Gravatar\" class=\"userimage\" height=\"20\" src=\"http://gravatar.com/avatar/0cef130e32e054dd516c99e5181d30c4?default=identicon&amp;size=20\" width=\"20\" />"
  end
end
