require 'nitter_scraper'

class TwitterApi < ApplicationRecord
  # Each twitter (now x) api instance is an object with a string 'handle' and a string 'twitterdata'

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

  # 'twitterdata' holds up to the last 80 tweets of a certain handle

  # A 'handle' is unique
  validates :handle, :presence => true, :uniqueness => true

  def update_tweets
    client = NitterScraper.new
    tweets = client.scrape_tweets(self.handle, 80, false)

    if not tweets.include?(:error)
      self.update_attribute(:twitterdata, tweets.to_json)
    end
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
