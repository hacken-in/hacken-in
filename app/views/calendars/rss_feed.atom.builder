atom_feed :language => 'de-DE' do |feed|
  feed.title "Nerdhub Termine"

  @single_events.each do |item|
    feed.entry(item, :url => event_single_event_path(item.event, item)) do |entry|
      entry.title item.full_name
      entry.content item.description, :type => 'html'
    end
  end

end
