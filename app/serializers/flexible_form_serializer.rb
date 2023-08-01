class FlexibleFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :form_type
  has_one :latest_version, serializer: FlexibleFormVersionSerializer
  has_one :group_manager
end
