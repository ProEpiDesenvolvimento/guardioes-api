# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :app

  acts_as_paranoid
  searchkick unless Rails.env.test?

  # Index name for a users is now:
  # classname_environment[if survey user has group, _groupmanagergroupname]
  # It has been overriden searchkick's class that sends data to elaticsearch,
  # such that the index name is now defined by the model that is being
  # evaluated using the function 'index_pattern_name'
  def index_pattern_name
    env = ENV['RAILS_ENV']
    return "users_#{env}" if group.nil?

    group_name = group.group_manager.group_name
    group_name.downcase!
    group_name.gsub! ' ', '-'
    "users_#{env}_#{group_name}"
  end

  has_many :households,
           dependent: :destroy

  has_many :surveys,
           dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  belongs_to :app
  belongs_to :group, optional: true
  has_one :school_unit

  validates :user_name,
            presence: true,
            length: {
              in: 1..255,
              too_long: I18n.translate('user.validations.user_name.too_long'),
              too_short: I18n.translate('user.validations.user_name.too_short')
            }

  validates :password,
            presence: true,
            length: {
              in: 8..255,
              too_long: I18n.translate('user.validations.password.too_long'),
              too_short: I18n.translate('user.validations.password.too_short')
            }

  validates :email,
            presence: true,
            length: {
              in: 1..255,
              message: 'Email deve seguir o formato: example@example.com'
            },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: I18n.translate('validations.email.message') },
            uniqueness: true

  # Data that gets sent as fields for elastic indexes
  def search_data
    elastic_data = as_json(except: %w[app_id group_id aux_code reset_password_token])
    elastic_data[:app] = app.app_name
    elastic_data[:group] = group&.get_path(string_only = true, labeled = false)&.join('/')
    elastic_data[:enrolled_in] = if !school_unit_id.nil? && SchoolUnit.where(id: school_unit_id).count.positive?
                                   SchoolUnit.where(id: school_unit_id)[0].description
                                 end
    elastic_data[:household_count] = households.count
    elastic_data
  end

  def update_streak(survey)
    if survey.household_id
      obj = survey.household
      last_survey = Survey.where('household_id = ?', survey.household_id).order('id DESC').offset(1).first
    else
      obj = self
      last_survey = Survey.where('user_id = ?', id).order('id DESC').offset(1).first
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
    obj = if survey.household_id
            survey.household
          else
            self
          end

    message = Message.where.not(feedback_message: [nil, '']).where('day = ?', obj.streak).first
    unless message
      message = Message.where.not(feedback_message: [nil, '']).where('day = ?', -1)
      index = obj.streak % message.size
      message = message[index]
    end
    message.feedback_message
  end

  scope :user_by_app_id, ->(current_user_app_id) { where(app_id: current_user_app_id) }
end
