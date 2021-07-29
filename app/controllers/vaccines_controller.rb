class VaccinesController < ApplicationController
    before_action :set_vaccine, only: [:update, :destroy]
    load_and_authorize_resource
  
    # GET /vaccines
    def index
      @user = current_devise_user
      @vaccines = Vaccine.filter_vaccine_by_app_id(@user.app_id)
      render json: @vaccines
    end
  
    # GET /vaccines/1
    def show
      render json: @vaccine
    end
  
    # POST /vaccines
    def create
			@vaccine = Vaccine.new(vaccine_params)
      @vaccine.app_id = current_devise_user.app_id

      if @vaccine.save
        render json: @vaccine, status: :created, location: @vaccine
      else
        render json: @vaccine.errors, status: :unprocessable_entity
      end
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
          :id,
          :app_id,
          :name, 
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
  