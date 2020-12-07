# frozen_string_literal: true

class HouseholdsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_household, only: %i[show update destroy]
  before_action :set_user, only: %i[index create]

  # GET /households
  def index
    @households = Household.filter_by_user(current_user.id)
    render json: @households
  end

  # GET /households/1
  def show
    render json: @household
  end

  # POST /households
  def create
    @household = Household.new(household_params)
    @household.user_id = @user.id

    if @household.save
      @user.reindex
      render json: @household, status: :created, location: user_household_path(id: @user)
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

  def set_user
    @user = User.find(current_user.id)
  end

  # Only allow a trusted parameter "white list" through.
  def household_params
    params.require(:household).permit(
      :description,
      :birthdate,
      :country,
      :gender,
      :race,
      :kinship,
      :user_id,
      :picture,
      :school_unit_id,
      :identification_code,
      :risk_group,
      :group_id
    )
  end
end
