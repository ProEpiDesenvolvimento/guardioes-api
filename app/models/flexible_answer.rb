class FlexibleAnswer < ApplicationRecord
  belongs_to :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  belongs_to :user

  def auth_ephem()
    uri = URI("#{ENV['EPHEM_API_URL']}/oauth/token")
    res = HTTParty.post(uri, body: { grant_type: 'password', username: ENV['EPHEM_API_USER'], password: ENV['EPHEM_API_PASS'] })
    token = res['access_token']
    return token
  end

  def report_ephem()
    # Get parsed data
    parsed_data = JSON.parse(self.data)

    eventData = {
      'eventoIntegracaoTemplate' => '/1',
      'userId' => self.user.id,
      'userEmail' => self.user.email,
      'eventSourceId' => 1,
      'eventSourceLocation' => 'comunidade B',
      'eventSourceLocationId' => 1,
      'data' => {
          'general_hazard_id' => 7,
          'confidentiality' => 'everyone',
          'specific_hazard_id' => 7,
          'state_id' => 77,
          'country_id' => 31,
          'district_ids' => [
            1
          ],
          'signal_type' => 'opening',
          'report_date' => '{{today}}',
          'incident_date' => '{{today}}'
      },
      'aditionalData' => {
          'Tipo de Notificação' => 'Coletiva',
          'Tipo de Ocorrência' => 'Em Humanos',
          'Quantos Envolvidos' => 'Mais de 5',
          'Exemplo 2' => 'Valor 2',
          'TesteX' => 'Valor 3'
      }
    }

    # Report case
    uri = URI("#{ENV['EPHEM_API_URL']}/api-integracao/v1/eventos")
    res = HTTParty.post(uri, body: eventData, headers: { Authorization: '' })
  end
end
