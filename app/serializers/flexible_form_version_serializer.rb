class FlexibleFormVersionSerializer < ActiveModel::Serializer
  attributes :id, :version, :notes, :data, :version_date
  has_one :flexible_form
end
