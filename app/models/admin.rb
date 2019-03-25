class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist

  belongs_to :app

  validates_presence_of :first_name, :last_name, :email, :is_god, :app_id
  
  validates :first_name,
    length: {
      minimum: 1,
      too_short: I18n.translate("admin.validations.first_name.too_short"),
      maximum: 255,
      too_long: I18n.translate("admin.validations.first_name.too_long")
    }
  validates :last_name,
    length: {
      minimum: 1,
      too_short: I18n.translate("admin.validations.last_name.too_short"),
      maximum: 255,
      too_long: I18n.translate("admin.validations.last_name.too_long")
    }
  validates :email,
    length: {
      minimum: 1,
      maximum: 255,
      too_long: I18n.translate("validations.email.too_long"),
      too_short: I18n.translate("validation.email.too_short")
    }
    format: { 
      with: URI::MailTo::EMAIL_REGEXP, 
      message: I18n.translate("validations.email.message") 
    }
end
