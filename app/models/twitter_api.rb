class TwitterApi < ApplicationRecord
  # Each twitter api instance is an object with a string 'handle' and a string 'twitterdata'

  # 'twitterdata' holds tweets as a json array

  # Each tweet in 'twitterdata' is a json with the following data:
  # | created_at    | string          |
  # | full_text     | string          |
  # | id            | int             |
  # | id_str        | string          |
  # | images        | array of string |
  # | links         | array of string |
  # | name          | string          |
  # | screen_name   | string          |

  # 'twitterdata' holds up to the last 200 tweets of a certain handle

  # A 'handle' is unique
  validates :handle, :presence => true, :uniqueness => true

  def self.get_twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = "M8wPaN9rUYK7uWhS0Z3wyK5M3"
      config.consumer_secret     = "nSrWvv1SLC7j6OG6U4ZWpSUaMOhRtCkXHZhEy380MldKjLs2zs"
      config.access_token        = "2278065150-VNm0Jmx7iDsi237SfJGx60q1xnPBFslPEe5sB0B"
      config.access_token_secret = "31OJ3y9oSKRUJ5h8Uljq7oOnYx4x1OxyeHqm7xhHz5VRB"
    end
  end

  def update_tweets
    client = TwitterApi::get_twitter_client()
    current_tweets = get_tweets

    tweets = []

    client.user_timeline(self.handle, count: 200, exclude_replies: true, tweet_mode: 'compat').each do |tweet|
      data = JSON.parse(tweet.attrs.to_json)
      
      tweet_data = {
        created_at: data['created_at'],
        id: data['id'],
        id_str: data['id_str'],
        name: data['user']['name'],
        screen_name: data['user']['screen_name'],
        text: data['text']
      }
      
      is_retweet = !data['retweeted_status'].nil?

      images = []

      if is_retweet && media = data['retweeted_status']['entities']['media']
        media.each do |x|
          images << x['media_url']
        end
      end

      if media = data['entities']['media']
        media.each do |x|
          images << x['media_url']
        end
      end

      tweet_data['images'] = images

      tweets << tweet_data
    end

    self.update_attribute(:twitterdata, tweets.to_json())
  end

  def get_tweets
    data = self.twitterdata
    if data.nil?
      return []
    end
    data = JSON.parse(data)
    return data
  end
end
