class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :email, :birthdate, :country, :gender, :race, :is_professional, :picture, :app_id, :city, :state, :identification_code, :group_id, :school_unit_id, :risk_group

  belongs_to :app do
    link(:app) {app_url(object.app.id)}
  end

  has_many :households 
  # has_many :surveys




  def attributes(*args)
    h = super(*args)
    h[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
    h
  end

end