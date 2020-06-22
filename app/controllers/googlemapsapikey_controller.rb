class GooglemapsapikeyController < ApplicationController
  def index
    render json: {googlemapsapikey: ENV["GOOGLE_MAPS_API_KEY"]}
  end
end
