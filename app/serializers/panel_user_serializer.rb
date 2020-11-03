class PanelUserSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :email, :birthdate, :country, :gender, :race, :is_professional, :picture, :city, :state, :identification_code, :group_id, :school_unit_id, :risk_group, :group, :streak, :policy_version, :created_at, :is_vigilance, :phone

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