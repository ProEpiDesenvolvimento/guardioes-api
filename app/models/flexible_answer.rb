class FlexibleAnswer < ApplicationRecord
  belongs_to :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  belongs_to :user

  DEFAULT_NOT_SELECTED_VALUE = 0

  EMPTY_STRING = ''.freeze

  def report_ephem
    begin
      field_text_map = self.flexible_form_version.extract_data_as_map_field_text

      Rails.logger.info "field_text_map #{field_text_map}"

      parsed_data = JSON.parse(data)

      Rails.logger.info "respostas recebidas #{parsed_data}"

      field_value_map = parsed_data.map { |entry| { entry['field'] => entry['value'] } }.reduce({}, :merge)
      aditional_data = parsed_data.map { |entry| { field_text_map.fetch(entry['field'], entry['field']) => entry['value'] } }.reduce({}, :merge)

      event_data = {
        'eventoIntegracaoTemplate': '/1',
        'userId': user.id,
        'userEmail': user.email,
        'eventSourceId': id,
        'eventSourceLocation': EMPTY_STRING,
        'eventSourceLocationId': DEFAULT_NOT_SELECTED_VALUE,
        'data': field_value_map,
        'aditionalData': aditional_data
      }

      Rails.logger.info "dados a serem enviados para o ephem #{event_data} #{event_data.class}"

      headers = { Authorization: EMPTY_STRING, Accept: 'application/json', 'Content-Type': 'application/json' }
      uri = URI("#{ENV['EPHEM_API_URL']}/api-integracao/v1/eventos")
      res = HTTParty.post(uri, body: event_data.to_json, headers: headers, debug_logger: Logger.new(STDOUT))

      if res.success?
        Rails.logger.info "sucesso na integracao com ephem. status code #{res.code} body #{res.body}"
      else
        Rails.logger.error "erro na integracao com ephem. status code #{res.code} body #{res.body}"
      end
      res.parsed_response['id']
    rescue => e
      Rails.logger.error "erro na integracao com ephem. #{e.message}"
      nil
    end
  end
end
