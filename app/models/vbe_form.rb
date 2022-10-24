class VbeForm < ApplicationRecord
  has_many :vbe_answers,
    dependent: :destroy

  validates :title,
    presence: true

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
