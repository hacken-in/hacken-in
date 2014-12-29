class SitemapController < ApplicationController
  layout 'sitemap'
  respond_to :xml

  def show
    @single_events = SingleEvent.all # Associated events get fetched via default_scope
    respond_with @single_events
  end
end
