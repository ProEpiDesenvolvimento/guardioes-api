# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if !user.has_attribute?('is_god') || user == User
      set_permission(user.permission.id)
    end

    case user
      when Admin
        if user.is_god?
          can :manage, :all
        else
          can :manage, [ :manage, :group_manager, :symptom, :syndrome, :content, :user ]
        end
      when Manager
        can :read, convert_symbol(@permission.models_read)
        can :create, convert_symbol(@permission.models_create)
        can :update, convert_symbol(@permission.models_update)
        can :destroy, convert_symbol(@permission.models_destroy)
        can :manage, convert_symbol(@permission.models_manage)
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
        models << :symptom
      elsif new_array == "syndrome"
        models << :syndrome
      elsif new_array == "content"
        models << :content
      else 
        models << :user
      end
    end

    return models
  end
end
