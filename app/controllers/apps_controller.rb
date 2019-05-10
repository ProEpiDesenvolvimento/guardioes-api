class AppsController < ApplicationController
  before_action :authenticate_admin!
  before_action :authenticate_admin_is_god, except: :update
  before_action :set_app, only: [:show, :update, :destroy]

  # GET /apps
  def index
    @apps = App.all

    render json: @apps
  end

  # GET /apps/1
  def show
    render json: @app
  end

  # POST /apps
  def create
    if params[:access_apps_token] == Rails.application.credentials.access_to_apps || admin_signed_in?
      @app = App.new(app_params)
  
      if @app.save
        render json: @app, status: :created, location: @app
      else
        render json: @app.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /apps/1
  def update
    if @app.update(app_params)
      render json: @app
    else
      render json: @app.errors, status: :unprocessable_entity
    end
  end

  # DELETE /apps/1
  def destroy
    @app.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find(params[:id])
    end

    def authenticate_admin_is_god
      unless current_admin.is_god
        render json: { message: I18n.t("admin.not_god")}
      end
    end

    # Only allow a trusted parameter "white list" through.
    def app_params
      params.require(:app).permit(:app_name, :owner_country)
    end
end
