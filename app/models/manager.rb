class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  has_many :manager_group_permission, :class_name => 'ManagerGroupPermission'
  has_many :groups, :through => :manager_group_permission 

  def is_permitted?(group)
    while group.description != 'root_node'
      return true if self.groups.include? group
      group = group.parent
    end
    return false
  end
end
