# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # When user is Manager or GroupManagerTeam, get them permissions list
    if user && !user.has_attribute?('is_god') && !user.has_attribute?('city') && !user.has_attribute?('vigilance_email')
      set_permission(user.permission.id)
    end

    case user
      when Admin
        if user.is_god?
          can :manage, :all
        else
          can :read, App
          can :update, Admin, :id => user.id
          can :update, App, :id => user.app_id
          can :manage, [ Manager, CityManager, GroupManager, Content, Rumor ], :app_id => user.app_id
          can :manage, [ Symptom, Syndrome, Message, User, Vaccine, Category, PreRegister, Permission, :data_visualization ]
        end
      when Manager
        can :read, convert_symbol(@permission.models_read)
        can :create, convert_symbol(@permission.models_create)
        can :update, convert_symbol(@permission.models_update)
        can :destroy, convert_symbol(@permission.models_destroy)
        can :manage, convert_symbol(@permission.models_manage)
        can :update, Manager, :id => user.id
        can :update, [ CityManager ], :app_id => user.app_id
        can :manage, [ Message, PreRegister, Permission, :data_visualization ]
        cannot :manage, Permission, city_manager_id: nil
      when CityManager
        can :manage, User, :city => user.city
        can :manage, CityManager, :id => user.id
        can :manage, [ :data_visualization ]
        cannot :destroy, CityManager, :id => user.id
      when GroupManager
        can :update, GroupManager, :id => user.id
        can :manage, Survey 
        can :manage, [ User, Group ]
        can :manage, [ Form ], :id => user.form_id
        can :manage, [ FormQuestion, FormAnswer ], :form_id => user.form_id
        can :manage, [ Content, GroupManagerTeam ], :group_manager_id => user.id
        can :manage, [ Permission, :data_visualization ]
        cannot :manage, Permission, group_manager_team_id: nil
      when GroupManagerTeam
        can :read, convert_symbol(@permission.models_read)
        can :create, convert_symbol(@permission.models_create)
        can :update, convert_symbol(@permission.models_update)
        can :destroy, convert_symbol(@permission.models_destroy)
        can :manage, convert_symbol(@permission.models_manage)
        can :update, GroupManagerTeam, :id => user.id
      when User
        can :read, User, :id => user.id
        can :read, [ Form, FormQuestion ]
        can :read, [ Household, Survey, FormAnswer ], :user_id => user.id
        can :read, [ App, Content, Vaccine, Category ]
        can :create, [ Household, Survey, FormAnswer ]
        can :update, User, :id => user.id
        can :update, [ Household, Survey, FormAnswer, Dose ], :user_id => user.id
        can :destroy, User, :id => user.id
        can :destroy, [ Household, Survey, FormAnswer, Dose ], :user_id => user.id
    end
  end

  private 
  def set_permission(id)
    @permission = Permission.find(id)
  end

  # Convert array of string to symbol ["content"] to [:content] e.g
  def convert_symbol(array)
    models = %i[]
    array.each do |model|
      if model == "symptom"
        models << Symptom
      elsif model == "syndrome"
        models << Syndrome
      elsif model == "content"
        models << Content
      elsif model == "vaccine"
        models << Vaccine
      elsif model == "category"
        models << Category
      elsif model == "dashboard"
        models << :data_visualization
      elsif model == "user"
        models << User
      elsif model == "citymanager"
        models << CityManager
      elsif model == "vigilance"
        models << Survey
      end
    end

    return models
  end
end
