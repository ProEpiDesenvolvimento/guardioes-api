class AppSerializer < ActiveModel::Serializer
  attributes :id, :app_name, :owner_country, :twitter, :adminEmail

  def adminEmail
    if object.admins[0].nil?
      return nil
    else 
      object.admins[0].email
    end
  end

  has_many :contents
  has_many :symptoms
end
