class SyndromesController < ApplicationController
  before_action :set_syndrome, only: [:show, :update, :destroy]

  # GET /syndromes
  def index
    @syndromes = Syndrome.all

    render json: @syndromes
  end

  # GET /syndromes/1
  def show
    render json: @syndrome
  end

  # POST /syndromes
  def create
    @syndrome = Syndrome.new(syndrome_params)

    if @syndrome.save
      render json: @syndrome, status: :created, location: @syndrome
    else
      render json: @syndrome.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /syndromes/1
  def update
    if @syndrome.update(syndrome_params)
      render json: @syndrome
    else
      render json: @syndrome.errors, status: :unprocessable_entity
    end
  end

  # DELETE /syndromes/1 
  def destroy
    @syndrome.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_syndrome
      @syndrome = Syndrome.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def syndrome_params
      params.require(:syndrome).permit(:description, :details, message_attributes: [ :id, :title, :warning_message, :go_to_hospital_message ])
    end
end
