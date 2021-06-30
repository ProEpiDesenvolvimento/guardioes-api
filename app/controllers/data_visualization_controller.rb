require 'jwt'

class DataVisualizationController < ApplicationController
before_action :set_current_request_user, only: [:metabase_urls]

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
    exp_time = Time.now.to_i + metabase_config[:exp_time]

    case @current_request_user
      when current_admin
        params[:type] == "users" ? @dashboard_id = 8 : @dashboard_id = 7
        payload = {'params' => {'app' => @current_request_user.app_id}, 'resource' => {'dashboard' => @dashboard_id}}
      when current_manager
        params[:type] == "users" ? @dashboard_id = 8 : @dashboard_id = 7
        payload = {'params' => {'app' => @current_request_user.app_id}, 'resource' => {'dashboard' => @dashboard_id}}
      when current_city_manager
        params[:type] == "users" ? @dashboard_id = 12 : @dashboard_id = 11
        payload = {'params' => {'city' => @current_request_user.city}, 'resource' => {'dashboard' => @dashboard_id}}
      when current_group_manager
        case params[:type]
        when "users"
          @dashboard_id = 9
        when "surveys"
          @dashboard_id = 10
        when "biosecurity"
          @dashboard_id = 0
        when "vigilance"
          @dashboard_id = 18
      end
        payload = {'params' => {'group' => @current_request_user.id}, 'resource' => {'dashboard' => @dashboard_id}}
      when current_user
        puts "Common user"
    end

    puts payload.inspect

    iframe_urls = []
    exp_time = Time.now.to_i + metabase_config[:exp_time]
    payload['exp'] = exp_time
    token = JWT.encode payload, metabase_config[:secret_key]
    iframe_urls.append({
      :dashboard => payload['resource']['dashboard'],
      :iframe_url => "#{metabase_config[:site_url]}/embed/dashboard/#{token}#bordered=true&titled=true"
    })


    return render json: {
      'urls': iframe_urls
    }
  end

  private
    def set_current_request_user
      if not current_manager.nil?
        @current_request_user = current_manager
      elsif not current_group_manager.nil?
        @current_request_user = current_group_manager
      elsif not current_admin.nil?
        @current_request_user = current_admin
      elsif not current_city_manager.nil?
        @current_request_user = current_city_manager
      else
        return render json: { errors: "Token not found" }, status: :unprocessable_entity 
      end
    end
    
    # Only allow a trusted parameter "white list" through.
    def data_visualization_params
      params.require(:data_visualization).permit(:type)
    end
end