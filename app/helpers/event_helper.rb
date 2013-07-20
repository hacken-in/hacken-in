module EventHelper
  def tag_list_for_taggable(event)
    event.tag_list.collect { |tag| { name: tag } }.to_json.html_safe
  end

  def external_participation_data
    begin
    JSON.parse(cookies.signed[:hacken_daten] || "{}", symbolize_names: true)
    rescue
      {}
    end
  end
end
