require "spec_helper"

describe Radar::Twitter do

  let(:setting) {
    RadarSetting.create(url: "https://twitter.com/BerlinLispers")
  }

  subject { Radar::Twitter.new(setting) }

  context "parsing url" do

    it "should get the twitter handle from an url" do
      setting.url = "http://twitter.com/hacken_in"
      expect(subject.twitter_handle).to eq("hacken_in")
    end

    it "should get the handle from an https url" do
      setting.url = "https://twitter.com/hacken_in"
      expect(subject.twitter_handle).to eq("hacken_in")
    end

    it "should return handle even if http part is missing" do
      setting.url = "twitter.com/hacken_in"
      expect(subject.twitter_handle).to eq("hacken_in")
    end

    it "should also use the handle if only the handle was given and not a url" do
      setting.url = "hacken_in"
      expect(subject.twitter_handle).to eq("hacken_in")
    end

  end

  context "fetching tweets" do

    before :each do
      @first_tweets = [
        OpenStruct.new(id: 1, url: "http://twitter.com/BerlinLispers/1", full_text: "text"),
        OpenStruct.new(id: 2, url: "http://twitter.com/BerlinLispers/2", full_text: "text"),
        OpenStruct.new(id: 3, url: "http://twitter.com/BerlinLispers/3", full_text: "text")
      ]
      @second_tweets = [
        OpenStruct.new(id: 4, url: "http://twitter.com/BerlinLispers/4", full_text: "text"),
        OpenStruct.new(id: 5, url: "http://twitter.com/BerlinLispers/5", full_text: "text"),
        OpenStruct.new(id: 6, url: "http://twitter.com/BerlinLispers/6", full_text: "text")
      ]
    end

    it "should get a list of tweets when using it the first time" do
      client = instance_double(Twitter::REST::Client)
      expect(client).to receive(:user_timeline)
        .with("BerlinLispers", exclude_replies: true)
        .and_return(@first_tweets)

      events = subject.next_events(client)
      expect(events.count).to eq(3)
      expect(events.first[:id]).to eq(1)
      expect(events.first[:url]).to eq("http://twitter.com/BerlinLispers/1")
      expect(events.first[:description]).to eq("text")
    end

    it "should get only the not processed tweets when using the second time" do
      setting.entries.create(entry_id: "5")
      client = instance_double(Twitter::REST::Client)
      expect(client).to receive(:user_timeline)
        .with("BerlinLispers", exclude_replies: true)
        .and_return(@first_tweets)
      expect(client).to receive(:user_timeline)
        .with("BerlinLispers", exclude_replies: true, max_id: 3)
        .and_return(@second_tweets)

      events = subject.next_events(client)
      expect(events.count).to eq(6)
      expect(events.last[:id]).to eq(6)
      expect(events.last[:url]).to eq("http://twitter.com/BerlinLispers/6")
      expect(events.last[:description]).to eq("text")
    end

  end

end
