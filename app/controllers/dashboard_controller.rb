class DashboardController < ApplicationController
  def index
    users = User.all.group_by { |u| Date::MONTHNAMES[u.created_at.month] }
    apps = App.all
    surveys = Survey.all.group_by { |s| s.city }
    symptoms = Symptom.all

    # surveys.keys.each do |s|
    #   obj_arr = []
    # end

    render json: {year: DateTime.now.year, users: users, apps: apps, surveys: surveys, symptoms: symptoms}, status: :ok  
  end
end
