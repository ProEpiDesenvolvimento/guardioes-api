# frozen_string_literal: true

class DashboardController < ApplicationController
  # before_action :authenticate_admin!
  def index
    users = User.all.group_by { |u| Date::MONTHNAMES[u.created_at.month] }
    apps = App.all
    surveys = Survey.all.group_by(&:city)
    # surveys_week = Survey.all.group("DATE_TRUNC('week', created_at)").count
    surveys_week = Survey.all.group_by { |s| s.created_at.end_of_week }
    symptoms = Symptom.all

    all_users = User.all.length
    all_surveys = Survey.all.length

    render json: {
      year: DateTime.now.year,
      users: users,
      apps: apps,
      surveys: surveys,
      symptoms: symptoms,
      surveys_week: surveys_week,
      all_users: all_users,
      all_surveys: all_surveys
    }, status: :ok
  end
end
