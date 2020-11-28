class AppSerializer < ActiveModel::Serializer
  attributes :id, :app_name, :owner_country, :twitter, :adminEmail
  def adminEmail
    object.admins[0].email
  end

  has_many :contents
  has_many :symptoms
end
