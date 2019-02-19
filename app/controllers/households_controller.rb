class HouseholdsController < ApplicationController
  before_action :set_household, only: [:show, :update, :destroy]

  # GET /households
  def index
    @households = Household.all

    render json: @households
  end

  # GET /households/1
  def show
    render json: @household
  end

  # POST /households
  def create
    @household = Household.new(household_params)

    if @household.save
      render json: @household, status: :created, location: @household
    else
      render json: @household.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /households/1
  def update
    if @household.update(household_params)
      render json: @household
    else
      render json: @household.errors, status: :unprocessable_entity
    end
  end

  # DELETE /households/1
  def destroy
    @household.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Household.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def household_params
      params.require(:household).permit(:description, :birthdate, :country, :gender, :race, :kinship, :user_id)
    end
end
