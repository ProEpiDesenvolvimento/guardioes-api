class FlexibleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :data, :external_system_integration_id, :external_system_data, :created_at, :updated_at
  belongs_to :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  belongs_to :user

  def signals_dict
    scope
  end

  def external_system_data
    if object.external_system_integration_id.nil?
      nil
    else
      external_system_integration_id = object.external_system_integration_id.to_s
      result = signals_dict.fetch(external_system_integration_id,
                                  ExternalIntegrationService.default_event_value(external_system_integration_id))
      {
        "_embedded": {
          "signals": [result]
        }
      }
    end
  end
end
