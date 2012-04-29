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
        else I18n.localize(date, format: :long)
      end.html_safe
  end

  def truncate_html(html, length, opts)
    HTML_Truncator.truncate(html, length, opts).html_safe
  end

  def convert_markdown(markdown_text)
    markdown_compiler = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true, no_styles: true, safe_links_only: true))
    return raw markdown_compiler.render(markdown_text)
  end

  def collect_links(item)
    links = []
    unless item.url.blank?
      links << {url: item.url, title: truncate(item.url,length: 40)}
    end

    if item.class == Event && !item.twitter.blank?
      links << {url: "http://twitter.com/#{item.twitter}", title: "@#{item.twitter}"}
    elsif item.class == SingleEvent && !item.event.twitter.blank?
      links << {url: "http://twitter.com/#{item.event.twitter}", title: "@#{item.event.twitter}"}
    end

    unless item.twitter_hashtag.blank?
      links << {url: "https://twitter.com/search/%23#{CGI.escape item.twitter_hashtag}", title: "##{item.twitter_hashtag}"}
    end

    links
  end

end
