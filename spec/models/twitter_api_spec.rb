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
  describe '=> model functions' do
    context '=> get_tweets' do
      it 'names are found' do
        ta = create_twitter_api('x')
        ta.update_tweets
        expect(ta.get_tweets.nil?).to be(false)
        ta.get_tweets.each do |tweet|
          expect(tweet['name']).to eq('X')
        end
      end
    end
    it 'images are found' do
      ta = create_twitter_api('x')
      ta.update_tweets
      expect(ta.get_tweets.nil?).to be(false)
      images_found = false
      ta.get_tweets.each do |tweet|
        unless tweet['images'].nil?
          images_found = true
        end
      end
      expect(images_found).to be(true)
    end
    context '=> update_tweets' do
      it 'updates normally' do
        ta = create_twitter_api('x')
        ta.update_tweets
        expect(ta.twitterdata.nil?).to be(false)
      end
    end
  end
end
