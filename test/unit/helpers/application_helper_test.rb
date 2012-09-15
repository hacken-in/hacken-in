#encoding: utf-8
require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def test_day_output_helper
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
    assert_equal retval, day_output_helper(today)

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
    assert_equal retval, day_output_helper(tomorrow)

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
    assert_equal retval, day_output_helper(day_after_tomorrow)
  end

  def test_convert_markdown
    markdown_formatted_text = "I am *italic* and **bold**."
    assert_equal "<p>I am <em>italic</em> and <strong>bold</strong>.</p>\n", convert_markdown(markdown_formatted_text)

    text_with_arbitrary_html = "<script>I am so evil</script>"
    assert_no_match /<script>/, convert_markdown(text_with_arbitrary_html)
  end

  def test_convert_with_emoji
    mtext = "I am *italic* :smile:"
    assert_equal "<p>I am <em>italic</em> <img src=\"/assets/emojis/smile.png\" class=\"emoji\" title=\":smile:\" alt=\":smile:\" height=\"20\" width=\"20\"></p>\n", convert_markdown(mtext)
  end

  def test_convert_markdown_links
    markdown_formatted_text = "Let me [google](http://www.google.de) that for you"

    assert_equal "<p>Let me <a href=\"http://www.google.de\">google</a> that for you</p>\n", convert_markdown(markdown_formatted_text)
    assert_equal "<p>Let me <a href=\"http://www.google.de\" rel=\"nofollow\">google</a> that for you</p>\n", convert_markdown(markdown_formatted_text, true)
  end

  def test_collect_links
    event = Event.new(name: "Hallo")
    assert_equal 0, collect_links(event).length

    event.url = "http://example.com"
    assert_equal [{title: "http://example.com", url: "http://example.com"}], collect_links(event)

    event.twitter = "twitter"
    assert_equal [{title: "http://example.com", url: "http://example.com"},
                  {title: "@twitter", url: "http://twitter.com/twitter"}], collect_links(event)

    event.twitter_hashtag = "hashtag"
    assert_equal [{title: "http://example.com", url: "http://example.com"},
                  {title: "@twitter", url: "http://twitter.com/twitter"},
                  {title: "#hashtag", url: "https://twitter.com/search/%23hashtag"}], collect_links(event)

    single = FactoryGirl.create(:single_event)
    single.event.url = "http://example.com"
    single.event.twitter_hashtag = "hashtag"
    single.event.twitter_hashtag = "hashtag"
    assert_equal [{url: "http://example.com", title: "http://example.com"},
                  {url: "https://twitter.com/search/%23hashtag", title: "#hashtag"}], collect_links(single)
  end

end
