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

end
