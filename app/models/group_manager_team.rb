class GroupManagerTeam < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  acts_as_paranoid

  belongs_to :group_manager
  belongs_to :app

  has_many :manager_group_permission, :class_name => 'ManagerGroupPermission', :through => :group_manager
  has_many :groups, :through => :manager_group_permission 
  has_one :permission, dependent: :destroy
  accepts_nested_attributes_for :permission

  # Check if a group is permitted by recusively scaling group branch
  # confering if any of the groups are permitted on the way
  def is_permitted?(group)
    if self.permission != nil && !self.permission.models_manage.include?('group')
      return false
    end
    loop do
      return true if self.groups.include? group
      break if group.description == 'root_node'
      group = group.parent
    end
    return false
  end
end
