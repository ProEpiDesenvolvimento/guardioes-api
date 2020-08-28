class UserWithoutNameSerializer < ActiveModel::Serializer
  attributes :id, :birthdate, :country, :gender, :race, :is_professional, :app_id, :city, :state, :group_id, :school_unit_id, :risk_group
  def attributes(*args)
      h = super(*args)
      h[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
      h
  end
end 
