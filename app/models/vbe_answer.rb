class VbeAnswer < ApplicationRecord
  belongs_to :vbe_form

  validates :data,
    presence: true

  def get_data
    data = self.data
    if data.nil?
      return {}
    end
    data = JSON.parse(data)
    return data
  end
end
