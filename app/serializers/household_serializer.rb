class HouseholdSerializer < ActiveModel::Serializer
  attributes :id, :description, :birthdate, :country, :gender, :race, :kinship, :picture, :school_unit_id, :identification_code, :risk_group, :group
  has_one :user

  def group
    return nil if object.group.nil?
    object.group.get_path(string_only=true,labled=false).join('/')
  end
end
