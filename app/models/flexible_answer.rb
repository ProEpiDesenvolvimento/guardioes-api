class FlexibleAnswer < ApplicationRecord
  belongs_to :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  belongs_to :user

  DEFAULT_MOCK_ID_VALUE = 1
  DEFAULT_NOT_SELECTED_VALUE = 0

  def report_ephem()
    begin
      parsed_data = JSON.parse(data)
    rescue JSON::ParserError => e
      Rails.logger.error "erro ao converter respostas do gds em json: #{e.message}"
    end

    Rails.logger.info "respostas recebidas #{parsed_data}"

    additional_data = parsed_data.map { |entry| { entry['field'] => entry['value'] } }.reduce({}, :merge)

    event_data = {
      'eventoIntegracaoTemplate': '/1',
      'userId': user.id,
      'userEmail': user.email,
      'eventSourceId': DEFAULT_MOCK_ID_VALUE,
      'eventSourceLocation': additional_data['evento_data_ocorrencia'],
      'eventSourceLocationId': DEFAULT_MOCK_ID_VALUE,
      'data': {
        'general_hazard_id': DEFAULT_NOT_SELECTED_VALUE,
        'confidentiality': 'everyone',
        'specific_hazard_id': DEFAULT_NOT_SELECTED_VALUE,
        'state_id': DEFAULT_NOT_SELECTED_VALUE,
        'country_id': DEFAULT_NOT_SELECTED_VALUE,
        'district_ids': [],
        'signal_type': 'opening',
        'report_date': Date.strptime(additional_data['evento_data_ocorrencia'], "%d-%m-%Y").strftime("%Y-%m-%d"),
        'incident_date': Date.strptime(additional_data['evento_data_ocorrencia'], "%d-%m-%Y").strftime("%Y-%m-%d")
      },
      'aditionalData': additional_data
    }

    Rails.logger.info "dados a serem enviados para o ephem #{event_data} #{event_data.class}"

    headers = { Authorization: '', Accept: 'application/json', 'Content-Type': 'application/json' }
    uri = URI("#{ENV['EPHEM_API_URL']}/api-integracao/v1/eventos")
    res = HTTParty.post(uri, body: event_data.to_json, headers: headers, debug_logger: Logger.new(STDOUT))

    if res.success?
      Rails.logger.info "sucesso na integracao com ephem. status code #{res.code} body #{res.body}"
    else
      Rails.logger.error "erro na integracao com ephem. status code #{res.code} body #{res.body}"
    end
  end
end
