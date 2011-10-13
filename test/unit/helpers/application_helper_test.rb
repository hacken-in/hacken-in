require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def test_day_output_helper
    today = Date.today
    tomorrow = Date.today+1
    day_after_tomorrow = Date.today+2
    assert_equal "Heute", day_output_helper(today)
    assert_equal "Morgen", day_output_helper(tomorrow)
    assert_equal day_after_tomorrow.strftime("%d. %B %Y"), day_output_helper(day_after_tomorrow)
  end

  end
