class DoseSerializer < ActiveModel::Serializer
  attributes :id, :date, :dose, :user_id, :vaccine

  def vaccine
    id = object.vaccine_id
    @vaccine = Vaccine.find(id)
    {
      id: @vaccine.id,
      name: @vaccine.name,
      country_origin: @vaccine.country_origin,
      laboratory: @vaccine.laboratory,
      doses: @vaccine.doses,
      disease: @vaccine.disease,
      min_dose_interval: @vaccine.min_dose_interval
    }
  end
end