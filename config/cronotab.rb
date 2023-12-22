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

Crono.perform(TwitterApiUpdate).every 1.hour

class UserTagsUpdate
  def perform
    File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, 'Perform UserTagsUpdate') }
    User.all.each do |u|
      begin
        u.update_tags
      rescue
        File.open('log/crono.log' ,'a') {|f| f.puts(Time.now.getutc, "USER TAGS: Failed to update user id=#{u.id}") }
      end
    end
  end
end

Crono.perform(UserTagsUpdate).every 1.day, at: {hour: 00, min: 00}