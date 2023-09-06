class FlexibleFormVersion < ApplicationRecord
  belongs_to :flexible_form
  has_many :flexible_answers, dependent: :destroy
  def extract_data_as_map_field_text
    flexible_form_version_data = JSON.parse(data)
    flexible_form_version_data.map { |entry| { entry['field'] => entry['text'] } }.reduce({}, :merge)
  end
end
