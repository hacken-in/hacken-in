class TwitterFollower
  include TwitterClient

  def initialize(client = connect)
    @client = client
  end

  def follow
    not_followed_handles.each do |handle|
      puts "Following #{handle}"
      begin
        @client.follow(handle)
      rescue => e
        puts "Problems following #{handle}"
      end
    end
  end

  def not_followed_handles
    event_twitter_handles - following
  end

  def event_twitter_handles
    (
      Event.select(:twitter).uniq.map(&:twitter) +
      SingleEvent.select("single_events.twitter").uniq.map(&:twitter)
    ).compact.uniq.map(&:downcase).delete_if(&:blank?) - ["hacken_in"]
  end

  def following
    too_many_request_wrapper do
      @following_cache ||= @client.friends(include_user_entities: false, skip_status: true, count: 200).to_a.map(&:handle).map(&:downcase)
    end
    @following_cache
  end

end
