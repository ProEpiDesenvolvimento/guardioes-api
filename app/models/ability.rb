# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    permission_id = set_permission(user.permission_id)

    case user
      when Admin
          can :create, [ :content, :symptom ]
      when Manager
        can :read, convert_symbol(permission_id.models_read)
        can :create, convert_symbol(permission_id.models_create)
        can :update, convert_symbol(permission_id.models_update)
        can :destroy, convert_symbol(permission_id.models_destroy)
        can :manage, convert_symbol(permission_id.models_manage)
    end
  end

  private 
  def set_permission(id)
    Permission.find(id)
  end

  # Convert array of string to symbol [":content"] to [:content] e.g
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
