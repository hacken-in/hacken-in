class SitemapController < ApplicationController
  layout 'sitemap'
  respond_to :xml

  def index
    @single_events = SingleEvent.all # Associated events get fetched via default_scope
    respond_with @single_events
  end
end
