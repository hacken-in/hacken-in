module TwitterClient
  MAX_ATTEMPTS = 3

  def connect
    twitter_config = YAML.load_file("config/twitter.yml")
    Twitter::REST::Client.new do |config|
      config.consumer_key    = twitter_config["consumer_key"]
      config.consumer_secret = twitter_config["consumer_secret"]
      config.access_token    = twitter_config["access_token"]
      config.access_token_secret = twitter_config["access_token_secret"]
    end
  end

  def too_many_request_wrapper
    num_attempts = 0
    begin
      num_attempts += 1
      yield
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
