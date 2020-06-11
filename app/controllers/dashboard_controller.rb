class DashboardController < ApplicationController
  # before_action :authenticate_admin!
  def index
    threads = Array.new(5)
    
    threads[0] = Concurrent::Future.new { @symptoms = Symptom.all }
    threads[1] = Concurrent::Future.new { @users = User.all.group_by { |u| Date::MONTHNAMES[u.created_at.month] } }
    threads[2] = Concurrent::Future.new { @apps = App.all }
    threads[3] = Concurrent::Future.new { @surveys = Survey.all.group_by { |s| s.city } }
    threads[4] = Concurrent::Future.new { @surveys_week = Survey.all.group_by { |s| s.created_at.end_of_week } }
    
    threads.each {|thread| thread.execute}
    threads.each {|thread| thread.wait_or_cancel(1)}

    @all_users = User.all.length
    @all_surveys = Survey.all.length

    render json: {
      year: DateTime.now.year, 
      users: @users, 
      apps: @apps, 
      surveys: @surveys, 
      symptoms: @symptoms,
      surveys_week: @surveys_week,
      all_users: @all_users,
      all_surveys: @all_surveys
    }, status: :ok  
  end
end