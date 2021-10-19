class GroupManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :group_name,
             :vigilance_email, :twitter, :require_id, :id_code_length,
             :vigilance_syndromes, :url_godata, :username_godata, :password_godata,
             :created_by, :updated_by, :app_id, :first_access
  has_one :form

  def password_godata
    if object.password_godata
      begin
        crypt = ActiveSupport::MessageEncryptor.new(ENV['GODATA_KEY'])
        return crypt.decrypt_and_verify(object.password_godata)
      rescue
      end
    end
  end
end