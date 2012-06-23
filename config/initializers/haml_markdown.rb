module Haml::Filters::Markdown
  include Haml::Filters::Base
  lazy_require "redcarpet"

  def render(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML.new).render(text)
  end
end
