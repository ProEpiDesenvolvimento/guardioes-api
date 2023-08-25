class FlexibleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :data, :created_at, :updated_at, :external_system_integration_id, :external_system_data
  has_one :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  has_one :user

  def external_system_data
    if object.flexible_form.form_type == 'signal' and !object.external_system_integration_id.nil?
      begin
        Rails.logger.info "buscando sinais do evento #{object.external_system_integration_id}"
        url = "#{ENV['EPHEM_API_URL']}/api-integracao/v1/eventos/#{object.external_system_integration_id}/signals"
        response = HTTParty.get(url)
        response.parsed_response
      rescue StandardError => e
        Rails.logger.error "erro na integracao com ephem. #{e.message}"
        nil
      end
    end
  end
end
