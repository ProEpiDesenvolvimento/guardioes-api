class GroupManagerTeam < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  acts_as_paranoid

  has_one :permission, dependent: :destroy
  accepts_nested_attributes_for :permission

  belongs_to :group_manager
  belongs_to :app
end
