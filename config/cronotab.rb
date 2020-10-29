Rails.app_class.load_tasks

class TwitterApiUpdate
  def perform
    File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, 'Perform TwitterApiUpdate') }
    TwitterApi.all.each do |t|
      begin
        t.update_tweets
      rescue
        File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, 'TWITTER API: Failed to rescue twitter') }
      end
    end
  end
end

Crono.perform(TwitterApiUpdate).every 1.hour