class VbeFormsController < ApplicationController
  before_action :set_vbe_form, only: [:show, :update, :destroy]

  # GET /vbe_forms
  def index
    @vbe_forms = VbeForm.all

    render json: @vbe_forms
  end

  # GET /vbe_forms/1
  def show
    render json: @vbe_form
  end

  # POST /vbe_forms
  def create
    @vbe_form = VbeForm.new(vbe_form_params)

    if @vbe_form.save
      render json: @vbe_form, status: :created, location: @vbe_form
    else
      render json: @vbe_form.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vbe_forms/1
  def update
    if @vbe_form.update(vbe_form_params)
      render json: @vbe_form
    else
      render json: @vbe_form.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vbe_forms/1
  def destroy
    @vbe_form.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vbe_form
      @vbe_form = VbeForm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def vbe_form_params
      params.require(:vbe_form).permit(:title, :description, :data)
    end
end
