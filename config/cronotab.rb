Rails.app_class.load_tasks

class TwitterApiUpdate
  def perform
    File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, 'Perform TwitterApiUpdate') }
    TwitterApi.all.each do |t|
      begin
        t.update_tweets
      rescue
        File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, "TWITTER API: Failed to rescue nitter handle=#{t.handle}") }
      end
    end
  end
end

Crono.perform(TwitterApiUpdate).every 1.hour, at: {min: 00}

class UserUpdate
  def perform
    File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, 'Perform UserRanking') }
    User.all.each do |u|
      begin
        u.update_ranking
      rescue
        File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, "USER RANKING: Failed to update user ranking id=#{u.id}") }
      end
    end

    File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, 'Perform UserTagsUpdate') }
    User.all.each do |u|
      begin
        u.update_onesignal_tags
      rescue
        File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, "USER TAGS: Failed to update user id=#{u.id}") }
      end
    end
  end
end

Crono.perform(UserUpdate).every 1.day, at: {hour: 00, min: 00}
