class PreRegistersController < ApplicationController
  before_action :set_pre_register, only: [:show, :update, :destroy]

  # GET /pre_registers
  def index
    @pre_registers = PreRegister.all

    render json: @pre_registers
  end

  # GET /pre_registers/1
  def show
    render json: @pre_register
  end

  # POST /pre_registers
  def create
    @pre_register = PreRegister.new(pre_register_params)

    if @pre_register.save
      render json: @pre_register, status: :created, location: @pre_register
    else
      render json: @pre_register.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pre_registers/1
  def update
    if @pre_register.update(pre_register_params)
      render json: @pre_register
    else
      render json: @pre_register.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pre_registers/1
  def destroy
    @pre_register.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pre_register
      @pre_register = PreRegister.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pre_register_params
      params.require(:pre_register).permit(:cnpj, :phone, :organization_kind, :state, :company_name, :app_id)
    end
end
