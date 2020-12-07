# frozen_string_literal: true

class DataVisualizationController < ApplicationController
  def users_count
    render json: User.count
  end

  def surveys_count
    render json: Survey.count
  end

  def asymptomatic_surveys_count
    render json: Survey.where(symptom: []).count
  end

  def symptomatic_surveys_count
    render json: Survey.where.not(symptom: []).count
  end
end
