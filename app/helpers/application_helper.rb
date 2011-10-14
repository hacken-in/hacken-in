module ApplicationHelper

  def weekday_select_option
    daynames = t("date.day_names").collect.with_index {|x,i| [x,i]}
    daynames << daynames.delete_at(0)
    options_for_select(daynames)
  end

  def day_output_helper(date)
      date = date.to_date
      today = Date.today
      case
        when date == today then "Heute"
        when date == (today + 1) then "Morgen"
        else date.strftime("%d. %B %Y")
      end.html_safe
  end

end
