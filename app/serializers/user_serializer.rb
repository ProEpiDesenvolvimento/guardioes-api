class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :email, :birthdate, :gender, :race, :is_professional, :risk_group,
             :country, :state, :city, :group, :group_id, :identification_code, :streak,
             :policy_version, :is_vigilance, :phone, :created_at,
             :created_by, :updated_by, :deleted_by

  belongs_to :app do
    link(:app) {app_url(object.app.id)}
  end

  has_many :households 
  # has_many :surveys

  def group
    if object.group.nil?
      return nil
    end
    object.group.get_path(string_only=true,labled=false).join('/')
  end

  def attributes(*args)
    h = super(*args)
    h[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
    h
  end
end