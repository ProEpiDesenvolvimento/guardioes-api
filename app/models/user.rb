class User < ApplicationRecord
  belongs_to :app
  
  acts_as_paranoid
  if !Rails.env.test?
    searchkick
  end

  # Index name for a users is now:
  # classname_environment[if survey user has group, _groupmanagergroupname]
  # It has been overriden searchkick's class that sends data to elaticsearch, 
  # such that the index name is now defined by the model that is being 
  # evaluated using the function 'index_pattern_name'
  def index_pattern_name
    env = ENV['RAILS_ENV']
    if self.group.nil?
      return 'users_' + env
    end
    group_name = self.group.group_manager.group_name
    group_name.downcase!
    group_name.gsub! ' ', '-'
    return 'users_' + env + '_' + group_name
  end

  has_many :households,
    dependent: :destroy

  has_many :surveys,
    dependent: :destroy

  has_many :form_answers,
    dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  belongs_to :app
  belongs_to :group, optional: true
    
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
    elastic_data[:household_count] = self.households.count
    return elastic_data 
  end

  def update_streak(survey)
    if survey.household_id
      obj = survey.household
      last_survey = Survey.where("household_id = ?", survey.household_id).order("id DESC").offset(1).first
    else
      obj = self
      last_survey = Survey.where("user_id = ?", self.id).order("id DESC").offset(1).first
    end

    if last_survey
      if last_survey.created_at.day == survey.created_at.prev_day.day
        obj.streak += 1
      elsif last_survey.created_at.day != survey.created_at.day
        obj.streak = 1
      end
    else
      obj.streak = 1
    end
    obj.update_attribute(:streak, obj.streak)
  end

  def get_feedback_message(survey)
    if survey.household_id
      obj = survey.household
    else
      obj = self
    end
    
    message = Message.where.not(feedback_message: [nil, ""]).where("day = ?", obj.streak).first
    if !message
      message = Message.where.not(feedback_message: [nil, ""]).where("day = ?", -1)
      if message.size == 0
        return "Sua participação foi registrada."
      end
      index = obj.streak % message.size
      message = message[index]
    end
    return message.feedback_message
  end

  scope :user_by_app_id, ->(current_user_app_id) { where(app_id: current_user_app_id) }
end
