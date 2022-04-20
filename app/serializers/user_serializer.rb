class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :email, :birthdate, :gender, :race, :is_professional, :risk_group,
             :country, :state, :city, :group, :group_id, :identification_code, :streak,
             :policy_version, :is_vigilance, :phone, :doses, :created_at, :updated_at, :updated_by,
             :vaccine_id, :first_dose_date, :second_dose_date # remove on next release

  has_many :households 
  belongs_to :vaccine # remove on next release
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