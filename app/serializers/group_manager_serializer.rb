class GroupManagerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :group_name, #:group_permissions,
             :vigilance_email, :twitter, :require_id, :id_code_length,
             :vigilance_syndromes, :url_godata, :username_godata, :password_godata,
             :created_by, :updated_by, :app_id, :first_access
  has_many :group_manager_teams
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

  def group_permissions
    list = []
    object.groups.each do |g|
      list << { 
        group: g.get_path(string_only=true,labled=false).join('/'),
        id: g.id 
      }
    end
    list
  end
end