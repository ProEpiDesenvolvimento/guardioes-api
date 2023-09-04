require 'nokogiri'
require 'open-uri'
require 'uri'

class NitterScraper
  def rss_tweets(username)
    # Returns an array of 20 tweets
    begin
      xml_data = open("#{ENV['NITTER_URL']}/#{username}/rss").read
      doc = Nokogiri::XML(xml_data)

      title = doc.xpath('//channel/title').text
      profile_name = title.split('/').first.rstrip
      username = title.split('/').last.split('@').last

      tweets = []

      doc.xpath('//item').each do |item|
        parsed_date = DateTime.parse(item.at_xpath('pubDate').text)
        tweet_date = parsed_date.strftime('%a %b %d %H:%M:%S %z %Y')

        unformatted_id = item.at_xpath('link').text.split('/').last
        tweet_id_str = unformatted_id.gsub(/#m$/, '')
        full_text = item.at_xpath('description').text

        html_text = Nokogiri::HTML(full_text)
        img_tags = html_text.css('img')
        
        tweet_images = []
        if img_tags.any?
          img_tags.each do |img|
            tweet_images << get_image_url(img['src'])
          end
        end

        tweet = {
          created_at: tweet_date,
          id: tweet_id_str.to_i,
          id_str: tweet_id_str,
          name: profile_name,
          screen_name: username,
          text: item.at_xpath('title').text,
          images: tweet_images
        }
        tweets << tweet
      end

      tweets
    rescue StandardError => e
      { error: e.message }
    end
  end

  def scrape_tweets(username, count=20)
    # Returns an array of 20-count tweets
    begin
      start_time = Time.now

      response = HTTParty.get("#{ENV['NITTER_URL']}/#{username}")
      html_data = response.body
      page = Nokogiri::HTML(html_data)

      profile_name = page.at('.profile-card-fullname').text
      username = page.at('.profile-card-username').text.split('@').last
      
      tweets = []
      pages = (count.to_f / 20.0).ceil
      next_page = page.at('.show-more a')

      puts "Pages: #{pages}"

      pages.times do |i|
        puts "Page: #{i}"
        if i > 0
          response = HTTParty.get("#{ENV['NITTER_URL']}/#{username}#{next_page['href']}")
          html_data = response.body
          page = Nokogiri::HTML(html_data)

          next_page = page.at('.show-more a')
        end

        page.css('.timeline-item').each do |tweet_element|
          unless tweet_element['class']&.include?('show-more')
            tweet_date_element = tweet_element.at('.tweet-date a')
            parsed_date = DateTime.parse(tweet_date_element['title'])
            tweet_date = parsed_date.strftime('%a %b %d %H:%M:%S +0000 %Y')
            
            unformatted_id = tweet_date_element['href'].split('/').last
            tweet_id_str = unformatted_id.gsub(/#m$/, '')
            tweet_text = tweet_element.at('.tweet-content').text

            img_tags = tweet_element.css('.still-image')

            tweet_images = []
            if img_tags.any?
              img_tags.each do |img|
                tweet_images << get_image_url(img['href'])
              end
            end

            tweet = {
              created_at: tweet_date,
              id: tweet_id_str.to_i,
              id_str: tweet_id_str,
              name: profile_name,
              screen_name: username,
              text: tweet_text,
              images: tweet_images
            }
            tweets << tweet
          end
        end
      end

      end_time = Time.now
      elapsed_time = end_time - start_time
      puts "Elapsed time: #{elapsed_time}"
      
      puts tweets.count
      tweets.to_json
    rescue StandardError => e
      { error: e.message }
    end
  end

  def get_image_url(url)
    media_str = url.split('/').last
    media_decoded = URI.decode(media_str)
    image_url = "https://pbs.twimg.com/#{media_decoded}"
    image_url
  end
end
