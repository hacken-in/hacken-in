require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def test_day_output_helper
    today = Date.today
    assert_equal "Heute", day_output_helper(today)

    tomorrow = Date.today+1
    assert_equal "Morgen", day_output_helper(tomorrow)

    day_after_tomorrow = Date.today+2
    assert_equal I18n.localize(day_after_tomorrow, :format => :long), day_output_helper(day_after_tomorrow)
  end

  def test_convert_markdown
    markdown_formatted_text = "I am *italic* and **bold**."
    assert_equal "<p>I am <em>italic</em> and <strong>bold</strong>.</p>\n", convert_markdown(markdown_formatted_text)

    text_with_arbitrary_html = "<script>I am so evil</script>"
    assert_no_match /<script>/, convert_markdown(text_with_arbitrary_html)
  end

end
