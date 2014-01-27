class TwitterListUpdater
  include TwitterClient

  def initialize(client = connect)
    @client = client
  end

  def update
    twitter_handles = twitter_by_region
    Region.all.each do |region|
      add_missing_to_list(twitter_handles[region.id], list_for_region(region))
    end
  end

  def add_missing_to_list(handles, list)
     handles_in_list = members(list).map(&:screen_name)
     (handles - handles_in_list).each do |screen_name|
       @client.add_list_member(list, screen_name)
     end
  end

  def members(list)
    @list_members ||= Hash.new
    if @list_members[list].nil?
      too_many_request_wrapper do
        @list_members[list] = @client.list_members(list, include_user_entities: false, skip_status: true, count: 200).to_a
      end
    end
    @list_members[list]
  end

  def list_for_region(region)
    lists.find {|item|
      item.name.casecmp(region.name)
    }
  end

  def lists
    too_many_request_wrapper do
      @lists ||= @client.lists
    end
    @lists
  end

  def twitter_by_region
    result = Hash.new{|h, k| h[k] = []}
    (
      Event.select(:twitter, :region_id).where("twitter is not null and twitter != ''") +
      SingleEvent.select("single_events.twitter, single_events.region_id").where("single_events.twitter is not null and single_events.twitter != ''")
    ).each do |item|
      result[item.region_id] << item.twitter
    end
    result
  end

end
