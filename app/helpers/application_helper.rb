require 'redcarpet_extensions'

module ApplicationHelper

  def mobile?
    request.user_agent =~ /Mobile|webOS|Opera Mini|Opera Mobi/
  end

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

  def convert_markdown(markdown_text, without_follow = false)
    if without_follow
      render_class = HTMLwithoutFollow
    else
      render_class = Redcarpet::Render::HTML
    end

    markdown_compiler = Redcarpet::Markdown.new(render_class.new filter_html: true, no_styles: true, safe_links_only: true)
    raw markdown_compiler.render(markdown_text)
  end

  def collect_links(item)
    links = []

    unless item.url.blank?
      links << { url: item.url,
        title: truncate(item.url, length: 40)
      }
    end

    unless item.twitter.blank?
      links << { url: "http://twitter.com/#{item.twitter}",
        title: "@#{item.twitter}"
      }
    end

    unless item.twitter_hashtag.blank?
      links << { url: "https://twitter.com/search/%23#{CGI.escape item.twitter_hashtag}",
        title: "##{item.twitter_hashtag}"
      }
    end

    links
  end

  def string_for_rule(rule)
    if rule.validations_for(:day_of_week).first.occ == -1
      occurrence = "letzten"
    else
      occurrence = "#{rule.validations_for(:day_of_week).first.occ}."
    end
    "An jedem #{occurrence} #{I18n.t("date.day_names")[rule.validations_for(:day_of_week).first.day]} des Monats"
  end

end
