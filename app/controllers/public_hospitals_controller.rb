class PublicHospitalsController < ApplicationController
  before_action :set_public_hospital, only: [:show, :update, :destroy]

  # GET /public_hospitals
  def index
    @public_hospitals = PublicHospital.all

    render json: @public_hospitals
  end

  # GET /public_hospitals/1
  def show
    render json: @public_hospital
  end

  # POST /public_hospitals
  def create
    @public_hospital = PublicHospital.new(public_hospital_params)

    if @public_hospital.save
      render json: @public_hospital, status: :created, location: @public_hospital
    else
      render json: @public_hospital.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /public_hospitals/1
  def update
    if @public_hospital.update(public_hospital_params)
      render json: @public_hospital
    else
      render json: @public_hospital.errors, status: :unprocessable_entity
    end
  end

  # DELETE /public_hospitals/1
  def destroy
    @public_hospital.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_public_hospital
      @public_hospital = PublicHospital.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def public_hospital_params
      params.require(:public_hospital).permit(:description, :latitude, :longitude, :type, :phone, :details, :app_id)
    end
end
