class FlexibleFormVersionSerializer < ActiveModel::Serializer
  attributes :id, :version, :notes, :data, :version_date, :current_date
  belongs_to :flexible_form

  def current_date
    Time.now
  end
end
