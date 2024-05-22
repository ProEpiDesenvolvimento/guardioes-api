class ExternalIntegrationService
  DEFAULT_NOT_SELECTED_VALUE = 0
  DEFAULT_INTEGRATION_TEMPLE_ID = '/1'.freeze
  EMPTY_STRING = ''.freeze
  EPHEM_API_URL = ENV['EPHEM_API_URL']
  API_PATH = '/api-integracao/v1'.freeze
  HEADERS = { Authorization: EMPTY_STRING, Accept: 'application/json', 'Content-Type': 'application/json' }.freeze

  def self.empty_signals
    { '_embedded' => { 'signals' => [] } }
  end

  def self.default_event_value(event_id)
    {
      'eventId' => event_id,
      'dados' => {
        'signal_stage_state_id' => [1, 'Informado']
      }
    }
  end

  def self.convert_to_dict(signals_list)
    signals_list['_embedded']['signals'].each_with_object({}) do |signal, hash|
      hash[signal['eventId'].to_s] = signal
    end
  end

  def self.list_signals_by_user_id(page, size, user_id)
    url = build_url("/signals?page=#{page}&size=#{size}&user_id=#{user_id}")
    response = HTTParty.get(url)
    if response.success?
      Rails.logger.info "sucesso na integracao com ephem. status code #{response.code} body #{response.body}"
      response.parsed_response
    else
      Rails.logger.error "erro na integracao com ephem. status code #{response.code} body #{response.body}"
      empty_signals
    end
  rescue StandardError => e
    Rails.logger.error "erro na integracao com ephem. #{e.message}"
    empty_signals
  end

  def self.create_event(flexible_answer)
    user = flexible_answer.user
    id = flexible_answer.id
    field_text_map = flexible_answer.flexible_form_version.extract_data_as_map_field_text

    Rails.logger.info "field_text_map #{field_text_map}"

    parsed_data = JSON.parse(flexible_answer.data)

    Rails.logger.info "received data #{parsed_data}"

    return nil if negative_report?(parsed_data)

    parsed_data = parsed_data['answers'] if parsed_data.is_a?(Hash) && parsed_data.key?('answers')

    event_data = build_event_data(user, id, field_text_map, parsed_data)

    Rails.logger.info "dados a serem enviados para o ephem #{event_data} #{event_data.class}"

    uri = URI("#{EPHEM_API_URL}#{API_PATH}/eventos")
    res = HTTParty.post(uri, body: event_data.to_json, headers: HEADERS, debug_logger: Logger.new(STDOUT))

    parsed_response = handle_response(res)
    parsed_response&.dig('id')
  rescue StandardError => e
    Rails.logger.error "erro na integracao com ephem. #{e.message}"
    nil
  end

  def self.send_message(external_system_integration_id, message)
    url = "#{EPHEM_API_URL}#{API_PATH}/eventos/#{external_system_integration_id}/mensagens"
    body = { message: message }.to_json
    response = HTTParty.post(url, body: body, headers: HEADERS)
    handle_response(response)
  rescue StandardError => e
    Rails.logger.error "erro na integracao com ephem. #{e.message}"
    nil
  end

  def self.get_messages(event_id, page = 0, size = 99)
    url = "#{EPHEM_API_URL}#{API_PATH}/eventos/#{event_id}/mensagens?page=#{page}&size=#{size}"
    response = HTTParty.get(url, headers: HEADERS)
    parsed_response = handle_response(response)
    parsed_response&.dig('_embedded', 'mensagens')
  rescue StandardError => e
    Rails.logger.error "erro na integracao com ephem. #{e.message}"
    nil
  end

  def self.build_url(path)
    "#{EPHEM_API_URL}#{API_PATH}#{path}"
  end

  def self.negative_report?(parsed_data)
    parsed_data.is_a?(Hash) && parsed_data.key?('report_type') && parsed_data['report_type'] == 'negative'
  end

  def self.build_event_data(user, id, field_text_map, parsed_data)
    field_value_map = parsed_data.map { |entry| { entry['field'] => entry['value'] } }.reduce({}, :merge)
    aditional_data = parsed_data.map { |entry| { field_text_map.fetch(entry['field'], entry['field']) => entry['value'] } }
                                .reduce({}, :merge)

    {
      'eventoIntegracaoTemplate': DEFAULT_INTEGRATION_TEMPLE_ID,
      'userId': user.id,
      'userEmail': user.email,
      'eventSourceId': id,
      'eventSourceLocation': EMPTY_STRING,
      'eventSourceLocationId': DEFAULT_NOT_SELECTED_VALUE,
      'data': field_value_map,
      'aditionalData': aditional_data
    }
  end

  def self.handle_response(res)
    if res.success?
      Rails.logger.info "sucesso na integracao com ephem. status code #{res.code} body #{res.body}"
      res.parsed_response
    else
      Rails.logger.error "erro na integracao com ephem. status code #{res.code} body #{res.body}"
      nil
    end
  end
end