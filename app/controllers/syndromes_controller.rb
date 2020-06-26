class SyndromesController < ApplicationController
  before_action :set_syndrome, only: [:show, :update, :destroy]
  before_action :set_symptoms, only: [ :create ]
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
      create_nested_symptoms
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

    def create_nested_symptoms
      @symptoms.each do |symptom|
        created_symptom = Symptom.find_or_create_by!(description: symptom[:description]) do |symptomLinked|
          symptomLinked.code = symptom[:code],
          symptomLinked.details = symptom[:details]
          symptomLinked.priority = symptom[:priority]
          symptomLinked.syndrome_id = @syndrome.id
          symptomLinked.app_id = 1
        end
        syndrome_symptom_percentage = SyndromeSymptomPercentage.create(
          percentage: symptom[:percentage],
          symptom_id: created_symptom.id
        )
        created_symptom.syndrome_symptom_percentage = syndrome_symptom_percentage
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_syndrome
      @syndrome = Syndrome.find(params[:id])
    end

    def set_symptoms
       @symptoms = params[:symptoms]
    end

    # Only allow a trusted parameter "white list" through.
    def syndrome_params
      params.require(:syndrome).permit(
        :description,
        :details, 
        message_attributes: [  :title, :warning_message, :go_to_hospital_message ], 
        )
    end
end
