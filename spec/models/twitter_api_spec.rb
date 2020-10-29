require 'rails_helper'

def create_twitter_api(handle)
  twitterapi = TwitterApi.new(handle: handle)
  twitterapi.save()
  twitterapi
end

def retweet(image_links=0)
  media_list = []
  (1..image_links).each do |i|
    media_list << { media_url: i.to_s }
  end
  return {
    'created_at': 'created_at',
    'id': 'id',
    'id_str': 'id_str',
    'user': {
      'name': 'name',
      'screen_name': 'screen_name'
    },
    'text': 'text',
    'entities': {

    },
    'retweeted_status': {
      'entities': {
        'media': media_list
      }
    }
  }
end

def tweet(image_links=0)
  media_list = []
  (1..image_links).each do |i|
    media_list << { media_url: i.to_s }
  end
  return {
    'created_at': 'created_at',
    'id': 'id',
    'id_str': 'id_str',
    'user': {
      'name': 'name',
      'screen_name': 'screen_name'
    },
    'text': 'text',
    'entities': {
      'media': media_list
    }
  }
end

RSpec.describe TwitterApi, type: :model do

  # Mocks Twitter API Object
  Twitter::REST::Client = Struct.new(:appid) do
    # Mock class for tweet object from twitter API
    class MockTweet
      def initialize(arg)
        @data = arg
      end
      def attrs
        return @data
      end
    end
    # Mock function that returns fetched tweets
    def user_timeline(a=0,b=0)
      tweetlist = [
        MockTweet.new(
          retweet(image_links=2)
        ),
        MockTweet.new(
          tweet(image_links=2)
        )
      ]
      return tweetlist
    end
  end

  describe '=> model functions' do
    context '=> get_tweets' do
      it 'images are found' do
        ta = create_twitter_api('twitter')
        ta.update_tweets
        expect(ta.get_tweets.nil?).to be(false)
        ta.get_tweets.each do |tweet|
          expect(tweet['images'].length).to eq(2)
        end
      end
      it 'names are found' do
        ta = create_twitter_api('twitter')
        ta.update_tweets
        expect(ta.get_tweets.nil?).to be(false)
        ta.get_tweets.each do |tweet|
          expect(tweet['name']).to eq('name')
        end
      end
    end
    context '=> update_tweets' do
      it 'updates normally' do
        ta = create_twitter_api('twitter')
        ta.update_tweets
        expect(ta.twitterdata.nil?).to be(false)
      end
    end
  end
end
