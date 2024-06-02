require 'webmock/rspec'
require 'httparty'
require 'rails_helper_lite'
require_relative '../../app/services/external_integration_service'

RSpec.describe ExternalIntegrationService, type: :service do
  let(:flexible_answer) {
    double('FlexibleAnswer',
           id: 1,
           user: double('User', id: 1, email: 'mock@mock.com', user_name: 'User', phone: '9912345678', country: 'Brasil'),
           data: '{}',
           flexible_form_version: double('FlexibleFormVersion',
                                         extract_data_as_map_field_text: { 'data' => '{}' }))
  }

  describe '.convert_to_dict' do
    it 'converts signals list to a dictionary' do
      signals_list = {
        '_embedded' => {
          'signals' => [
            { 'eventId' => 1, 'name' => 'Signal 1' },
            { 'eventId' => 2, 'name' => 'Signal 2' }
          ]
        }
      }

      result = described_class.convert_to_dict(signals_list)

      expect(result).to eq({
                             '1' => { 'eventId' => 1, 'name' => 'Signal 1' },
                             '2' => { 'eventId' => 2, 'name' => 'Signal 2' }
                           })
    end
  end

  describe '.default_event_value' do
    it 'returns the default event value' do
      event_id = 1
      expected_result = {
        'eventId' => event_id,
        'dados' => {
          'signal_stage_state_id' => [1, 'Informado']
        }
      }

      result = described_class.default_event_value(event_id)

      expect(result).to eq(expected_result)
    end
  end

  describe '.list_signals_by_user_id' do
    before do
      stub_request(:get, /api-integracao/).
        to_return(status: 200, body: { '_embedded' => { 'signals' => [] } }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'fetches system data' do
      result = described_class.list_signals_by_user_id(0, 999, 1)
      expect(result).to eq({ '_embedded' => { 'signals' => [] } })
    end

    context 'when the http response is not successful' do
      before do
        stub_request(:get, /api-integracao/).
          to_return(status: 500, body: 'error message', headers: { 'Content-Type' => 'application/json' })
      end

      it 'logs the error and returns empty signals' do
        expect(Rails.logger).to receive(:error).with('erro na integracao com ephem. status code 500 body error message')
        result = described_class.list_signals_by_user_id(0, 999, 1)
        expect(result).to eq({ '_embedded' => { 'signals' => [] } })
      end
    end

    context 'when an error occurs' do
      before do
        stub_request(:get, /api-integracao/).to_raise(StandardError.new('error message'))
      end

      it 'logs the error and returns empty signals' do
        expect(Rails.logger).to receive(:error).with('erro na integracao com ephem. error message')
        result = described_class.list_signals_by_user_id(0, 999, 1)
        expect(result).to eq({ '_embedded' => { 'signals' => [] } })
      end
    end
  end

  describe '.create_event' do
    before do
      stub_request(:post, /api-integracao/).
        to_return(status: 200, body: { 'id' => '123' }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'reports to ephem and returns the response id' do
      result = described_class.create_event(flexible_answer)
      expect(result).to eq('123')
    end

    it 'report to ephem the anwers key as data' do
      allow(flexible_answer).to receive(:data).and_return('{"report_type": "positive", "answers": [{"field": "field1", "value": "value1"}]}')
      result = described_class.create_event(flexible_answer)
      expect(result).to eq('123')
      expect(WebMock).to have_requested(:post, /api-integracao/).with(body: {
        'eventoIntegracaoTemplate' => '/1',
        'userId' => 1,
        'userEmail' => 'mock@mock.com',
        'userName' => 'User',
        'userPhone' => '9912345678',
        'userCountry' => 'Brasil',
        'eventSourceId' => 1,
        'eventSourceLocation' => '',
        'eventSourceLocationId' => 0,
        'data' => { 'field1' => 'value1' },
        'aditionalData' => { 'field1' => 'value1' }
      }.to_json)
    end

    it 'does not report to ephem if the report type is negative' do
      allow(flexible_answer).to receive(:data).and_return('{"report_type": "negative"}')
      result = described_class.create_event(flexible_answer)
      expect(result).to be_nil
    end

    context 'when the http response is not successful' do
      before do
        stub_request(:post, /api-integracao/).
          to_return(status: 500, body: 'error message', headers: { 'Content-Type' => 'application/json' })
      end

      it 'logs the error and returns nil' do
        expect(Rails.logger).to receive(:error).with('erro na integracao com ephem. status code 500 body error message')
        result = described_class.create_event(flexible_answer)
        expect(result).to be_nil
      end
    end

    context 'when an error occurs' do
      before do
        stub_request(:post, /api-integracao/).to_raise(StandardError.new('error message'))
      end

      it 'logs the error and returns nil' do
        expect(Rails.logger).to receive(:error).with('erro na integracao com ephem. error message')
        result = described_class.create_event(flexible_answer)
        expect(result).to be_nil
      end
    end
  end

  describe '.get_messages' do
    let(:event_id) { 1 }
    let(:response_body) do
      {
        '_embedded' => {
          'mensagens' => [
            {
              'date' => '2024-05-19 20:00:15',
              'subject' => '',
              'id' => 127,
              'body' => 'Uma mensagem de teste',
              'signal_id' => 15,
              'message_type' => 'comment',
              'partner_ids' => [3],
              'author_id' => {
                'id' => 7,
                'name' => 'GDS App Bot'
              }
            }
          ]
        },
        '_links' => {
          'self' => {
            'href' => 'http://vbeapi.online/api-integracao/v1/eventos/366/mensagens?page=0&size=99'
          }
        },
        'page' => {
          'size' => 99,
          'totalElements' => 1,
          'totalPages' => 1,
          'number' => 0
        }
      }
    end

    before do
      stub_request(:get, /api-integracao/)
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'gets messages and returns the response' do
      result = described_class.get_messages(event_id)
      expect(result).to eq(response_body['_embedded']['mensagens'])
    end

    context 'when the http response is not successful' do
      before do
        stub_request(:get, /api-integracao/).
          to_return(status: 500, body: 'error message', headers: { 'Content-Type' => 'application/json' })
      end

      it 'logs the error and returns nil' do
        expect(Rails.logger).to receive(:error).with('erro na integracao com ephem. status code 500 body error message')
        result = described_class.get_messages(event_id)
        expect(result).to be_nil
      end
    end

    context 'when an error occurs' do
      before do
        stub_request(:get, /api-integracao/).to_raise(StandardError.new('error message'))
      end

      it 'logs the error and returns nil' do
        expect(Rails.logger).to receive(:error).with('erro na integracao com ephem. error message')
        result = described_class.get_messages(event_id)
        expect(result).to be_nil
      end
    end
  end

  describe '.send_message' do
    let(:event_id) { 1 }
    let(:response_body) do
      {
        'message' => 'Testando novamente do Integrador'
      }
    end

    before do
      stub_request(:post, /api-integracao/)
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'send message and returns the response' do
      result = described_class.send_message(event_id, 'Testando novamente do Integrador')
      expect(result).to eq(response_body)
    end

    context 'when the http response is not successful' do
      before do
        stub_request(:post, /api-integracao/).
          to_return(status: 500, body: 'error message', headers: { 'Content-Type' => 'application/json' })
      end

      it 'logs the error and returns nil' do
        expect(Rails.logger).to receive(:error).with('erro na integracao com ephem. status code 500 body error message')
        result = described_class.send_message(event_id, 'Any')
        expect(result).to be_nil
      end
    end

    context 'when an error occurs' do
      before do
        stub_request(:post, /api-integracao/).to_raise(StandardError.new('error message'))
      end

      it 'logs the error and returns nil' do
        expect(Rails.logger).to receive(:error).with('erro na integracao com ephem. error message')
        result = described_class.send_message(event_id, 'Any')
        expect(result).to be_nil
      end
    end
  end
end