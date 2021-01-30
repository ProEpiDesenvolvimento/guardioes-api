# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if !user.has_attribute?('is_god') && !user.has_attribute?('country') && !user.has_attribute?('vigilance_email')
      set_permission(user.permission.id)
    end
    Rails.logger.debug("USER: #{user}")
    case user
      when Admin
        if user.is_god?
          can :manage, :all
        else
          can :manage, [ Manager, GroupManager, Symptom, Syndrome, Content, User ]
          can :update, Admin, :id => user.id
        end
      when Manager
        can :read, convert_symbol(@permission.models_read)
        can :create, convert_symbol(@permission.models_create)
        can :update, convert_symbol(@permission.models_update)
        can :update, Manager, :id => user.id
        can :destroy, convert_symbol(@permission.models_destroy)
        can :manage, convert_symbol(@permission.models_manage)
      when GroupManager
        can :manage, [ User, Group ]
        can :update, GroupManager, :id => user.id
      when User
        can :manage, :all
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
      else 
        models << User
      end
    end

    return models
  end
end
