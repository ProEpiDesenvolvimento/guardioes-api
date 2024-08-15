class FlexibleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :data, :external_system_integration_id, :external_system_data, :created_at, :updated_at
  belongs_to :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  belongs_to :user

  def signals_dict
    scope.is_a?(Hash) ? scope : {}
  end

  def external_system_data
    if object.external_system_integration_id.nil?
      nil
    else
      external_system_integration_id = object.external_system_integration_id.to_s
      integration_service = ExternalIntegrationService.new(object.user)
      result = signals_dict.fetch(external_system_integration_id,
                                  integration_service.default_event_value(external_system_integration_id))
      {
        "_embedded": {
          "signals": [result]
        }
      }
    end
  end
end
