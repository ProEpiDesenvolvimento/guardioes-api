class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :email, :birthdate, :gender, :race, :risk_group, :country, :state, :city,
             :group, :group_id, :identification_code, :streak, :reported_this_week, :policy_version,
             :is_professional, :is_vbe, :in_training, :is_vigilance, :phone, :doses, :created_at, :updated_at, :updated_by

  has_many :households
  belongs_to :category

  belongs_to :app do
    link(:app) {app_url(object.app.id)}
  end

  def group
    if object.group.nil?
      return nil
    end
    object.group.get_path(string_only=true,labled=false).join('/')
  end

  def doses
    if object.doses.nil?
      return 0
    end
    object.doses.count
  end

  def attributes(*args)
    h = super(*args)
    h[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
    h
  end
end