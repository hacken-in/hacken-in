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
      render_class = MdEmoji::Render
    end

    markdown_compiler = Redcarpet::Markdown.new(render_class.new filter_html: true, no_styles: true, safe_links_only: true)
    raw markdown_compiler.render(markdown_text)
  end

  def collect_links(item)
    links = []

    if item.url.present?
      links << { url: item.url,
        title: truncate(item.url, length: 40)
      }
    end

    if item.twitter.present?
      links << { url: "http://twitter.com/#{item.twitter}",
        title: "@#{item.twitter}"
      }
    end

    if item.twitter_hashtag.present?
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

  def avatar_for_user(user, size=16, class_name=nil)
    if user.image_url?
      image_tag(user.image_url, width: size, alt: user.nickname, class: class_name)
    else
      gravatar_image_tag(user.email, class: class_name, gravatar: { default: :identicon, size: size })
    end
  end

end
