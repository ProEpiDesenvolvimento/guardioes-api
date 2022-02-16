class RumorsController < ApplicationController
  before_action :set_rumor, only: [:show, :update, :destroy]
  authorize_resource only: [:show, :index, :update, :destroy]
  
  def create
    @rumor = Rumor.new(rumors_params)
    @rumor.app_id = current_devise_user.app_id

    if @rumor.save
      render json: @rumor
    else
      render json: {error: true, message: "Erro", data: @rumor.errors}, status: :unprocessable_unity
    end
  end

  def show
    render json: @rumor
  end

  def index
    @rumors = Rumor.where(app_id: current_devise_user.app_id)
    render json: @rumors
    
  end

  def update
    if @rumor.update(rumors_params)
      render json: @rumor
    else
      render json: @rumor.errors
    end
  end

  def destroy
    if @rumor.destroy
      render json: @rumor
    else
      render json: @rumor.errors
    end
  end

  def set_rumor
    @rumor = Rumor.find(params[:id])
  end

  private
  def rumors_params
    params.require(:rumor).permit(
      :title, 
      :description, 
      :confirmed_cases, 
      :confirmed_deaths
    )
  end
end
