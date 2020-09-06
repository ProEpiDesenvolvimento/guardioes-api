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
  belongs_to :group, optional: true
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

  # Data that gets sent as fields for elastic indexes
  def search_data
    elastic_data = self.as_json(except:['app_id', 'group_id', 'aux_code', 'reset_password_token'])
    elastic_data[:app] = self.app.app_name
    if !self.group.nil?
      elastic_data[:group] = self.group.get_path(string_only=true, labeled=false).join('/')
    else
      elastic_data[:group] = nil
    end
    if !self.school_unit_id.nil? and SchoolUnit.where(id:self.school_unit_id).count > 0
      elastic_data[:enrolled_in] = SchoolUnit.where(id:self.school_unit_id)[0].description 
    else 
      elastic_data[:enrolled_in] = nil 
    end
    elastic_data[:household_count] = self.households.count
    return elastic_data 
  end

  def update_streak(survey)
    last_survey = Survey.filter_by_user(self.id).order("id DESC").offset(1).first
    if last_survey.created_at.day == survey.created_at.prev_day.day
      self.streak += 1
    else
      self.streak = 1
    end
    self.update_attribute(:streak, self.streak)
  end

  def get_feedback_message
    if self.streak % 3 == 0 || self.streak == 1
      index = (self.streak / 3).to_i
      message = Message.where.not(feedback_message: [nil, ""]).order("id ASC")[index]
      return message.feedback_message
    elsif self.streak == 112
      message = Message.where.not(feedback_message: [nil, ""]).order("id ASC").last
      return message.feedback_message
    else
      return nil
    end
  end
end
