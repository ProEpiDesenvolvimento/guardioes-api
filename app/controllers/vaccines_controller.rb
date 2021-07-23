class VaccinesController < ApplicationController
    before_action :authenticate_admin!
  
    # GET /apps
    def index
      @vaccines = Vaccine.all
      render json: @vaccines
    end
  
    # GET /vaccines/1
    def show
      @vaccine = Vaccine.where(vaccine_id: @vaccine.id)
      newVaccine = {vaccine: @vaccine}.merge({admin: @admin})
      render json: newApps
    end
  
    # POST /vaccines
    def create
			@vaccine = Vaccine.new(vaccine_params)
			@vaccine.save
			render json: @vaccine
    end
  
    # PATCH/PUT /vaccines/1
    def update
      if @vaccine.update(vaccine_params)
        render json: @vaccine
      else
        render json: @vaccine.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /vaccines/1
    def destroy
      @vaccine.destroy
    end
  
  
    private

      # Only allow a trusted parameter "white list" through.
      def vaccine_params
        params.require(:vaccine).permit(:name)
      end
  end
  