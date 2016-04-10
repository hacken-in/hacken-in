#encoding: utf-8
require 'redcarpet_extensions'

module ApplicationHelper

  def sitename
    if current_region.present?
      "hacken.in/#{current_region.main_slug}"
    else
      "hacken.in"
    end
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
    if rule.instance_of? IceCube::MonthlyRule
      string_for_monthly_rule(rule)
    elsif rule.instance_of? IceCube::WeeklyRule
      string_for_weekly_rule(rule)
    end
  end

  def string_for_monthly_rule(rule)
    if rule.validations_for(:day_of_week).first.occ == -1
      occurrence = "letzten"
    else
      occurrence = "#{rule.validations_for(:day_of_week).first.occ}."
    end
    "An jedem #{occurrence} #{I18n.t("date.day_names")[rule.validations_for(:day_of_week).first.day]} des Monats"
  end

  def string_for_weekly_rule(rule)
    occurrence = ""
    if rule.validations_for(:interval).first.interval > 1
      occurrence = "#{rule.validations_for(:interval).first.interval}."
    end
    "An jedem #{occurrence} #{I18n.t("date.day_names")[rule.validations_for(:day).first.day]}"
  end

  def avatar_for_user(user, size = 16, class_name = nil)
    if user.gravatar_email.present?
      gravatar_image_tag(user.gravatar_email, title: user.nickname, alt: user.nickname, class: class_name, gravatar: { default: :identicon, size: size })
    elsif user.email.present?
      gravatar_image_tag(user.email, title: user.nickname, alt: user.nickname, class: class_name, gravatar: { default: :identicon, size: size })
    else
      image_tag(user.image_url, width: size, title: user.nickname, alt: user.nickname, class: class_name)
    end
  end

  def avatar_for_external_user(external_user, size = 16, class_name = nil)
    gravatar_image_tag(external_user.email, title: external_user.name, alt: external_user.name, class: class_name, gravatar: { default: :identicon, size: size })
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
