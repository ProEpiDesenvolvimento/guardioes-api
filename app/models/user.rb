class User < ApplicationRecord
  acts_as_paranoid
  # Index name for a user is now:
  # classname_environment[if user has group, _groupmanagergroupname]
  # For these changes to take effect, a reindex of the entire database is needed
  # Don't touch searchkick's functionalities before reading the comment on
  # the search_data function, in this file.
  searchkick index_name: 'trash_data'

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
    # READ THIS BEFORE TOUCHING THE FOLLOWING IF CONDITION

    # The following is a solution to dynamically assign index names (during runtime)
    # THE SOLUTION IS A HACK. Working with the library searchkick was not an option because it does  
    # not provide a way to select during object create and update runtime the name of the index we 
    # want to send the data to. The workaroud is to run the indexing twice in the following way:

    # Pre-condition: In searchkick's module inclusion, up there ^^, index name is set as 'trash_data'
    # and @reindex_control is NOT true
    
    # 1. The first time though, @reindex_control will be not true, therefore it enter the if below
    # 2. Now we set searchkick's static index name variable as the name we want
    # 3. We now set @reindex_control as true
    # 4. We call reindex and during reindexing, the program loop comes right back to this function
    # 5. Now the reindexing is running and @@searchkick_index has the index name we want
    # 6. We set the index to the "standard" name of 'trash_data' and @reindex_control to false,  
    #    thus fulfilling the pre-condition for further object use
    # 7. Reindex has ended, we now send to the index 'trash_data' the empty object {}

    # This solution is terrible but I could not think of a better one as of now
    # If you want to solve this better, read searchkick's source code: github.com/ankane/searchkick

    if @reindex_control != true
      @@searchkick_index = index_pattern_name
      @reindex_control = true
      self.reindex
      return {}
    else
      @@searchkick_index = 'trash_data'
      @reindex_control = false
    end

    # End of hack

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
end
