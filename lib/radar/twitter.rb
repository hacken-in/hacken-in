require 'ruby_meetup'

module Radar
  class Twitter < Base
    include TwitterClient

    def next_events(client = connect)
      tweets(client).map do |tweet|
        {
          id: tweet.id,
          url: tweet.url.to_s,
          description: tweet.full_text
        }
      end
    end

    def tweets(client, page_id = nil)
      messages = if page_id.nil?
                   client.user_timeline(twitter_handle, exclude_replies: true)
                 else
                   client.user_timeline(twitter_handle, exclude_replies: true, max_id: page_id)
                 end
      if last_tweet_id != 0 && !messages.map(&:id).include?(last_tweet_id)
        messages += tweets(client, messages.last.id)
      end
      messages
    end

    def last_tweet_id
      @last_tweet_id ||= if @radar_setting.entries.empty?
                           0
                         else
                           @radar_setting.entries.last.entry_id.to_i
                         end
    end

    def twitter_handle
      m = @radar_setting.url.match(/^(?:http(?:s)?\:\/\/)?(?:twitter.com\/)?([A-Za-z0-9_]*)$/)
      m[1] if m
    end

  end

end
