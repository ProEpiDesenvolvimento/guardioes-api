class SyndromesController < ApplicationController
  before_action :set_syndrome, only: [:show, :update, :destroy]
  before_action :set_symptoms, only: [:create]
  authorize_resource except: [:index, :show]

  # GET /syndromes
  def index
    @user = current_devise_user
    @syndromes = Syndrome.filter_syndrome_by_app_id(@user.app_id)

    render json: @syndromes
  end

  # GET /syndromes/1
  def show
    render json: @syndrome
  end

  # POST /syndromes
  def create
    @symptoms = syndrome_params[:symptom]
    @syndrome = Syndrome.new(syndrome_params.except(:symptom))
    if @syndrome.save
      @syndrome.update_attribute(:created_by, current_devise_user.email)
      if !syndrome_params[:symptom].nil?
        create_symptoms_and_connections
      end
      render json: @syndrome, status: :created, location: @syndrome
    else
      render json: @syndrome.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /syndromes/1
  def update
    @symptoms = syndrome_params[:symptom]
    if @syndrome.update(syndrome_params.except(:symptom))
      @syndrome.update_attribute(:updated_by, current_devise_user.email)
      if !syndrome_params[:symptom].nil?
        update_symptoms_and_connections
      end
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

    def create_symptoms_and_connections
      @symptoms.each do |symptom|
        created_symptom = Symptom.find_or_create_by!(description: symptom[:description]) do |symptomLinked|
          symptomLinked.code = symptom[:code]
          symptomLinked.details = symptom[:details]
          symptomLinked.priority = symptom[:priority]
          symptomLinked.app_id = current_admin.app_id
        end
        syndrome_symptom_percentage = SyndromeSymptomPercentage.create(
          percentage: symptom[:percentage] || 0,
          symptom: created_symptom,
          syndrome: @syndrome
        )
      end
    end

    def update_symptoms_and_connections
      @symptoms.each do |symptom|
        created_symptom = Symptom.find_or_create_by!(description: symptom[:description]) do |symptomLinked| # Create or fetch
          symptomLinked.code = symptom[:code],
          symptomLinked.details = symptom[:details]
          symptomLinked.priority = symptom[:priority]
          symptomLinked.app_id = symptom[:app_id] || 1
        end
        if SyndromeSymptomPercentage.where(syndrome: @syndrome, symptom: created_symptom).any?              # If connection exists, update percentage
          connection = SyndromeSymptomPercentage.where(syndrome:@syndrome,symptom:created_symptom)[0]
          connection.percentage = symptom[:percentage] || 0
          connection.save()
        else                                                                                                # Otherwise, create
          syndrome_symptom_percentage = SyndromeSymptomPercentage.create(
            percentage: symptom[:percentage] || 0,
            symptom: created_symptom,
            syndrome: @syndrome
          )
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_syndrome
      @syndrome = Syndrome.find(params[:id])
    end

    def set_symptoms
      @symptoms = params[:symptom]
    end

    # Only allow a trusted parameter "white list" through.
    def syndrome_params
      params.require(:syndrome).permit(
        :description,
        :details,
        :days_period,
        :app_id,
        :threshold_score,
        :symptom => [[ :description, :code, :percentage, :details, :priority, :app_id ]],
        message_attributes: [ :title, :warning_message, :go_to_hospital_message ]
      )
    end
end
