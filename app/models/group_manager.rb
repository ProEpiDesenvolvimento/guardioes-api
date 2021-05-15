class GroupManager < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  after_create :create_twitter_api
  after_save :create_twitter_api
  after_update :create_twitter_api

  has_many :manager_group_permission, :class_name => 'ManagerGroupPermission', dependent: :delete_all
  has_many :groups, :through => :manager_group_permission 
  has_one :form, dependent: :destroy
  has_one :permission, dependent: :destroy

  serialize :vigilance_syndromes, Array
  
  # Check if a group is permitted by recusively scaling group branch
  # confering if any of the groups are permitted on the way
  def is_permitted?(group)
    loop do
      return true if self.groups.include? group
      break if group.description == 'root_node'
      group = group.parent
    end
    return false
  end

  # Creates a twitter for a group managers twitter handle 
  def create_twitter_api
    begin
      TwitterApi.new(
        handle: self.twitter
      ).save()
    rescue
    end
  end

  def form_id
    if self != nil
      if self.form != nil
        return self.form.id
      end
    end
    return nil
  end
end
