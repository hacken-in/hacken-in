class EventSweeper < ActionController::Caching::Sweeper
  observe Event

  def after_create(event)
    expire_cache_for(event)
  end

  # If our sweeper detects that a event was updated call this
  def after_update(event)
    expire_cache_for(event)
  end

  # If our sweeper detects that a event was deleted call this
  def after_destroy(event)
    expire_cache_for(event)
  end

  private

  def expire_cache_for(event)
    expire_fragment("event_occurences_#{event.id}")
    expire_action(:controller => '/welcome', :action => 'index')
  end
end
