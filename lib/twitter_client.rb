module TwitterClient
  MAX_ATTEMPTS = 3

  def connect
    Twitter::REST::Client.new do |config|
      config.consumer_key    = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret = Rails.application.secrets.twitter_consumer_secret
      config.access_token    = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
    end
  end

  def request_wrapper
    num_attempts = 0
    begin
      raise "Giving up after #{num_attempts} attempts." if num_attempts >= MAX_ATTEMPTS
      num_attempts += 1
      yield
    rescue Twitter::Error::TooManyRequests => error
      puts "Rate limit for twitter, sleeping #{error.rate_limit.reset_in} seconds."
      sleep error.rate_limit.reset_in
      retry
    end
    @following_cache
  end
end
