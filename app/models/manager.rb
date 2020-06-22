class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  has_many :groups, dependent: :destroy
end
