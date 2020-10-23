# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    permission_id = set_permission(user.permission_id)

    case user
      when Admin
          can :create, [ :content, :symptom ]
      when Manager
        can :read, convert_symbol(permission_id.models_create)
        can :read, convert_symbol(permission_id.models_read)
        can :update, convert_symbol(permission_id.models_update)
        can :destroy, convert_symbol(permission_id.models_destroy)
        can :manage, convert_symbol(permission_id.models_destroy)
      end
  end

  private 
  def set_permission(id)
    Permission.find(id)
  end

  # Convert arrayn of string to symbol [":content"] to [:content] e.g
  def convert_symbol(array)
    array.each do |convert|
      array.to_sym
    end
  end
end

