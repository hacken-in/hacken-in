require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def test_day_output_helper
    today = Date.today
    tomorrow = Date.today+1
    assert_equal "Heute", day_output_helper(today)
    assert_equal "Morgen", day_output_helper(tomorrow)
  end

  end
