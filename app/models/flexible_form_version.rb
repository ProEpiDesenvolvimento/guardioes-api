class FlexibleFormVersion < ApplicationRecord
  belongs_to :flexible_form
  has_many :flexible_answers, dependent: :destroy
  def extract_data_as_map_field_text
    flexible_form_version_data = JSON.parse(data)
    if flexible_form_version_data.is_a?(Hash) && flexible_form_version_data.key?('questions')
      flexible_form_version_data = flexible_form_version_data['questions']
    end
    flexible_form_version_data.map { |entry| { entry['field'] => entry['text'] } }.reduce({}, :merge)
  end
end
