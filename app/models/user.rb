class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_paranoid
  searchkick
  
  has_many :households,
    dependent: :destroy

  has_many :surveys,
    dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  belongs_to :app
  #belongs_to :group
  has_one :school_unit,
    dependent: :destroy
    
  validates :user_name,
    presence: true,
    length: {
      in: 1..255,
      too_long: I18n.translate("user.validations.user_name.too_long"),
      too_short: I18n.translate("user.validations.user_name.too_short")
    }

  validates :password,
    presence: true,
    length: {
      in: 8..255,
      too_long: I18n.translate("user.validations.password.too_long"),
      too_short: I18n.translate("user.validations.password.too_short")
    }

  validates :email,
    presence: true,
    length: {
      in: 1..255,
      message: "Email deve seguir o formato: example@example.com"
    },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.translate("validations.email.message") },
    uniqueness: true
end
