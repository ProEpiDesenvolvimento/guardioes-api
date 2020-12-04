require 'jwt'

class DataVisualizationController < ApplicationController
  def users_count
    return render json: User.count
  end

  def surveys_count
    return render json: Survey.count
  end

  def asymptomatic_surveys_count
    return render json: Survey.where(symptom:[]).count
  end

  def symptomatic_surveys_count
    return render json: Survey.where.not(symptom:[]).count
  end

  def metabase_urls
    metabase_config = Rails.application.config.metabase
    iframe_urls = []
    exp_time = Time.now.to_i + metabase_config[:exp_time]
    params['payloads'].each {
      | payload |
        token = JWT.encode payload, metabase_config[:secret_key]
        iframe_url = metabase_config[:site_url] + "/embed/question/" + token + "#bordered=true&titled=true"
        iframe_urls.append({
          :question => payload['resource']['question'],
          :iframe_url => iframe_url
        })
    }
  
    return render json: {
      'urls': iframe_urls
    }
    end
end
