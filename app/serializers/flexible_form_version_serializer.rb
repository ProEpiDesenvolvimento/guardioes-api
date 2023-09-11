class FlexibleFormVersionSerializer < ActiveModel::Serializer
  attributes :id, :version, :notes, :data, :version_date
  belongs_to :flexible_form
end
