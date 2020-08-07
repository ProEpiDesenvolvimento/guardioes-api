class TwitterApisController < ApplicationController
  before_action :set_twitter_api, only: [:show, :update, :destroy]
  before_action :authenticate_admin!, except: [:index, :show]

  # GET /twitter_apis
  def index
    twitter_apis = []
    TwitterApi.all.each do |t|
      twitter_apis << t.handle
    end
    return render json: twitter_apis.to_json()
  end

  # GET /twitter_apis/1
  def show
    render json: @twitter_api
  end

  # POST /twitter_apis
  def create
    @twitter_api = TwitterApi.new(twitter_api_params)

    if @twitter_api.save
      render json: @twitter_api, status: :created, location: @twitter_api
    else
      render json: @twitter_api.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /twitter_apis/1
  def update
    if @twitter_api.update(twitter_api_params)
      render json: @twitter_api
    else
      render json: @twitter_api.errors, status: :unprocessable_entity
    end
  end

  # DELETE /twitter_apis/1
  def destroy
    @twitter_api.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_twitter_api
      twitter_handle = params[:id]
      if twitter_handle[0] == '@'
        twitter_handle = twitter_handle[1..twitter_handle.length]
      end
      @twitter_api = TwitterApi.find_by_handle(twitter_handle)
      if @twitter_api.twitterdata.nil?
        @twitter_api.update_tweets
      end
    end

    # Only allow a trusted parameter "white list" through.
    def twitter_api_params
      params
        .require(:twitter_api)
        .permit(
          :handle
        )
    end
end
