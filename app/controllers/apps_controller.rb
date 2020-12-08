# frozen_string_literal: true

# Apps Controller
class AppsController < ApplicationController
  before_action :authenticate_admin!, except: [:get_twitter]
  before_action :authenticate_admin_is_god, except: %i[update show get_twitter]
  before_action :set_app, only: %i[show update destroy get_twitter]

  load_and_authorize_resource

  # GET /apps
  def index
    @apps = App.all
    render json: @apps
  end

  # GET /apps/1
  def show
    @admin = Admin.where(app_id: @app.id)
    new_apps = { app: @app }.merge({ admin: @admin })
    render json: new_apps
  end

  # POST /apps
  def create
    return unless params[:access_apps_token] == Rails.application.credentials.access_to_apps || admin_signed_in?

    @app = App.new(app_params)

    if @app.save
      render json: @app, status: :created, location: @app
    else
      render json: @app.errors, status: :unprocessable_entity
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

  # GET /apps/:id/get_twitter
  # rubocop:disable Naming/AccessorMethodName
  def get_twitter
    # rubocop:enable Naming/AccessorMethodName
    render json: { twitter: @app.twitter }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = App.find(params[:id])
  end

  def authenticate_admin_is_god
    render json: { message: I18n.t('admin.not_god') } unless current_admin.is_god
  end

  # Only allow a trusted parameter "white list" through.
  def app_params
    params.require(:app).permit(:app_name, :owner_country, :twitter)
  end
end
