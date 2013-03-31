#encoding: utf-8
require 'redcarpet_extensions'

module ApplicationHelper

  def day_output_helper(date)
      date = date.to_date
      today = Date.today
      date_ext = case
        when date == today then " - Heute"
        when date == (today + 1) then " - Morgen"
        when date == (today + 2) then " - Übermorgen"
      end

      retval = <<-EOL
        <div class='calendar-datebox-d'>
          #{date.strftime('%d')}
        </div>
        <div class='calendar-datebox-box'>
          <div class='calendar-datebox-my'>#{I18n.localize(date, format: '%b %Y')}</div>
          <div class='calendar-datebox-wd'>#{I18n.localize(date, format: '%A')}</div>
        </div>#{date_ext}
      EOL
      retval.html_safe
  end

  def truncate_html(html, length=30, opts={})
    HTML_Truncator.truncate(html, length, opts).html_safe
  end

  def html_unsafe_convert_markdown(markdown_text, without_follow=false)
    return "" if markdown_text.nil?

    if without_follow
      render_class = HTMLwithoutFollow
    else
      render_class = MdEmoji::Render
    end

    markdown_compiler = Redcarpet::Markdown.new(render_class.new filter_html: false, no_styles: true, safe_links_only: true, no_intra_emphasis: true)
    markdown_compiler.render(ActionController::Base.helpers.sanitize(markdown_text))
  end

  def convert_markdown(markdown_text, without_follow=false)
    raw html_unsafe_convert_markdown(markdown_text, without_follow)
  end

  alias :html_safe_convert_markdown :convert_markdown

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

  # -----------------------------------------------------------
  # Devise methods (needed if a loginform is displayed on a page
  # other than the actual login page)
  # -----------------------------------------------------------
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  # -----------------------------------------------------------
  # End of Devise methods
  # -----------------------------------------------------------

end
