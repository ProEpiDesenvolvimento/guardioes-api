# frozen_string_literal: true

class RumorsController < ApplicationController
  before_action :authenticate_user!

  def create
    @rumor = Rumor.new(rumors_params)

    if @rumor.save
      render json: { error: false, message: 'Sucesso', data: @rumor }, status: :created
    else
      render json: { error: true, message: 'Erro', data: @rumor.errors }, status: :unprocessable_unity
    end
  end

  private

  def rumors_params
    params.require(:rumor).permit(
      :title,
      :event_description,
      :confirmed_cases,
      :confirmed_deaths
    )
  end
end
