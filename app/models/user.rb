class User < ApplicationRecord
  belongs_to :app
  belongs_to :vaccine, optional: true
  belongs_to :category, optional: true

  acts_as_paranoid

  has_many :households,
    dependent: :destroy

  has_many :surveys,
    dependent: :destroy

  has_many :rumors,
    dependent: :destroy

  has_many :doses,
    dependent: :destroy

  has_many :form_answers,
    dependent: :destroy

  has_many :flexible_answers,
    dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  belongs_to :app
  belongs_to :group, optional: true

  validates_presence_of :birthdate, 
                        :country
    
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

  # Data that gets sent as fields
  def search_data
    data = self.as_json(except:['app_id', 'group_id', 'aux_code', 'reset_password_token'])
    data[:app] = self.app.app_name
    if !self.group.nil?
      data[:group] = self.group.get_path(string_only=true, labeled=false).join('/')
    else
      data[:group] = nil
    end
    data[:household_count] = self.households.count
    return data 
  end

  def update_streak(survey)
    if survey.household_id
      obj = survey.household
      last_survey = Survey.where("household_id = ?", survey.household_id).order("id DESC").offset(1).first
    else
      obj = self
      last_survey = Survey.where("user_id = ?", self.id).order("id DESC").offset(1).first
      obj.update_attribute(:reported_this_week, true)
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

  def update_ranking
    obj = self

    current_week = Time.zone.now.strftime('%U').to_i
    last_flexible_answer_week = -1
    last_survey_week = -1

    if obj.is_professional
      last_flexible_answer = FlexibleAnswer.where("user_id = ?", obj.id).order("id DESC").limit(1).first

      if last_flexible_answer
        last_flexible_answer_week = last_flexible_answer.created_at.strftime('%U').to_i
      end
      reported_this_week = (current_week == last_flexible_answer_week)
      
      obj.update_attribute(:reported_this_week, reported_this_week)
    else
      last_survey = Survey.where("user_id = ?", obj.id).order("id DESC").limit(1).first

      if last_survey
        if last_survey.created_at.beginning_of_day < Time.zone.now.prev_day.beginning_of_day
          obj.streak = 0
        end
        last_survey_week = last_survey.created_at.strftime('%U').to_i
      else
        obj.streak = 0
      end
      reported_this_week = (current_week == last_survey_week)

      obj.update_attributes(streak: obj.streak, reported_this_week: reported_this_week)
    end
  end

  def update_onesignal_tags
    obj = self

    tagsData = {
      "tags" => {
        "streak": obj.streak.to_s,
        "reported_this_week": obj.reported_this_week ? '1' : '0'
      }
    }
    uri = URI("#{ENV["ONESIGNAL_API_URL"]}/apps/#{ENV["ONESIGNAL_APP_ID"]}/users/#{obj.id}")
    res = HTTParty.put(uri, body: tagsData, headers: { 'Content-Type' => 'application/json' })
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
