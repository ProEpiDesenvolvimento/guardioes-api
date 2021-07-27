class VaccinesController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_vaccine, only: [:update, :destroy]
  
    # GET /vaccines
    def index
      @vaccines = Vaccine.all
      render json: @vaccines
    end
  
    # GET /vaccines/1
    def show
      @vaccine = Vaccine.where(id: params['id'])
      render json: @vaccine
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
      render json: @vaccine
    end
  
  
    private

      def vaccine_params
        params.permit(
          :name, 
          :app_id, 
          :laboratory, 
          :country_origin,
          :min_dose_interval,
          :max_dose_interval,
          :doses,
        )
      end

      def set_vaccine
        @vaccine = Vaccine.find(params[:id])
      end
  end
  