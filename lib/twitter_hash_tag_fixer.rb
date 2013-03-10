module TwitterHashTagFixer

  def self.included(base)
    base.class_eval do
      before_save :fix_twitter
    end
  end

  def fix_twitter
    if twitter 
      if twitter[0] == '@'
        self.twitter = twitter[1..-1]
      elsif m = twitter.match(/http(?:s)?:\/\/twitter.com\/(.*)/)
        self.twitter = m[1]
      end
    end

    if twitter_hashtag
      if twitter_hashtag[0] == '#'
        self.twitter_hashtag = twitter_hashtag[1..-1]
      end
    end
  end

end
