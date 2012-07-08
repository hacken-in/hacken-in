module EventHelper
  def tag_list_for_taggable(event)
    event.tag_list.collect { |tag| { name: tag } }.to_json.html_safe
  end
end
