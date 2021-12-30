class DosesController < ApplicationController
  before_action :check_params, only: [:create, :update]
  before_action :check_pertence, only: [:update, :destroy]

  def index
    @doses = Dose.where(user_id: current_user.id)

    render json: @doses
  end

  def create
    @dose = Dose.new(dose_params)
    
    @dose.user = User.find(current_user.id)
    @dose.vaccine = Vaccine.find(params[:vaccine_id])

    if @dose.save
      render json: @dose
    else
      render json: @dose.errors
    end
  end

  def update
    @dose.vaccine = Vaccine.find(params[:vaccine_id])

    if @dose.update(dose_params)
      render json: @dose
    else
      render json: @dose.errors
    end
  end

  def destroy
    if @dose.destroy
      render json: {message: "A dose foi apagada com sucesso."}
    else
      render json: @dose.errors
    end
  end

  private 

  def dose_params
    params.permit(:date, :dose)
  end

  def check_params
    return render json: {error: "Vacina inexistente"}, status: 400 unless Vaccine.exists?(params[:vaccine_id])
  end

  def check_pertence
    return render json: {error: "Dose inexistente"}, status: 400 unless Dose.exists?(params[:id])
    @dose = Dose.find(params[:id])
    return render json: {error: "A dose não está associada a este usuário"}, status: 401 unless @dose.user_id === current_user.id
  end
end