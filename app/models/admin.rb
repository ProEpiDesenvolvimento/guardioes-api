class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist

  belongs_to :app
  
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "only allows valid emails" }
end
