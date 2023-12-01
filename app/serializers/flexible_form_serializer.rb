class FlexibleFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :form_type, :app_id
  has_one :flexible_form_version, serializer: FlexibleFormVersionSerializer
  belongs_to :group_manager
end
