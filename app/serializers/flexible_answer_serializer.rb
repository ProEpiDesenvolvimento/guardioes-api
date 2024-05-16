class FlexibleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :data, :external_system_integration_id, :external_system_data, :created_at, :updated_at
  belongs_to :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  belongs_to :user

  def external_system_data
    if object.flexible_form.form_type == 'signal' and !object.external_system_integration_id.nil?
      begin
        parsed_data = JSON.parse(object.data)
        if parsed_data.is_a?(Hash) && parsed_data.key?('report_type') && parsed_data['report_type'] == 'negative'
          # report_type negative, ephem api will not be called
          return nil
        end

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
