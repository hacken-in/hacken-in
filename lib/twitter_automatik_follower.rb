class TwitterAutomatikFollower
  MAX_ATTEMPTS = 3

  def initialize
    twitter_config = YAML.load_file("config/twitter.yml")
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key    = twitter_config["consumer_key"]
      config.consumer_secret = twitter_config["consumer_secret"]
      config.access_token    = twitter_config["access_token"]
      config.access_token_secret = twitter_config["access_token_secret"]
    end
  end

  def follow(client = @client)
    not_followed_handles.each do |handle|
      puts "Following #{handle}"
      client.follow(handle)
    end
  end

  def not_followed_handles
    event_twitter_handles - following
  end

  def event_twitter_handles
    (
      Event.select(:twitter).uniq.map(&:twitter) +
      SingleEvent.select("single_events.twitter").uniq.map(&:twitter)
    ).compact.uniq
  end

  def following
    num_attempts = 0
    begin
      num_attempts += 1
      @following_cache ||= @client.friends(include_user_entities: false, skip_status: true, count: 200).to_a.map(&:handle)
    rescue Twitter::Error::TooManyRequests => error
      if num_attempts <= MAX_ATTEMPTS
        puts "Rate limit for twitter, sleeping #{error.rate_limit.reset_in}"
        sleep error.rate_limit.reset_in
        retry
      else
        raise
      end
    end
    @following_cache
  end

end
