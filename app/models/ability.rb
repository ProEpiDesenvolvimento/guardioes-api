# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # not admin, user, city manager and group manager
    if user && !user.has_attribute?('is_god') && !user.has_attribute?('city') && !user.has_attribute?('vigilance_email')
      set_permission(user.permission.id)
    end

    case user
      when Admin
        if user.is_god?
          can :manage, :all
        else
          can :read, App
          can :read, [ CityManager ], :app_id => user.app_id
          can :update, App, :id => user.app_id
          can :update, [ CityManager ], :app_id => user.app_id
          can :update, Admin, :id => user.id
          can :manage, [ Manager, GroupManager, Symptom, Syndrome, Content, User ]
        end
      when Manager
        can :read, convert_symbol(@permission.models_read)
        can :read, [ CityManager ], :app_id => user.app_id
        can :create, convert_symbol(@permission.models_create)
        can :update, convert_symbol(@permission.models_update)
        can :update, [ CityManager ], :app_id => user.app_id
        can :update, Manager, :id => user.id
        can :destroy, convert_symbol(@permission.models_destroy)
        can :manage, convert_symbol(@permission.models_manage)
      when GroupManager
        can :manage, [ User, Group ]
        can :manage, [ Form ], :id => user.form_id
        can :manage, [ FormQuestion, FormAnswer ], :form_id => user.form_id
        can :update, GroupManager, :id => user.id
      when CityManager
        can :manage, User, :city => user.city
        can :manage, CityManager, :id => user.id
        cannot :destroy, CityManager, :id => user.id
      when User
        can :read, [ App, Content, Household, Survey, Symptom ]
        can :read, User, :id => user.id
        can :read, [ Form ]
        can :read, [ FormQuestion, FormAnswer ]
        can :create, [ Household, Survey, FormAnswer ]
        can :update, User, :id => user.id
        can :update, [ Household, Survey, FormAnswer ], :user_id => user.id
        can :destroy, User, :id => user.id
        can :destroy, [ Household, Survey, FormAnswer ], :user_id => user.id
    end
  end

  private 
  def set_permission(id)
    @permission = Permission.find(id)
  end

  # Convert array of string to symbol ["content"] to [:content] e.g
  def convert_symbol(array)
    models = %i[]
    array.each do |new_array|
      if new_array == "symptom"
        models << Symptom
      elsif new_array == "syndrome"
        models << Syndrome
      elsif new_array == "content"
        models << Content
      elsif new_array == "citymanager"
        models << CityManager
      else 
        models << User
      end
    end

    return models
  end
end
