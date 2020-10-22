# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    case user
      when Admin
          can :create, [ :content, :symptom ]
      when Manager
        can :create, set_permission(user.permission_id).models_create
        # can :read, user.permission.models_read
        # can :update, user.permission.models_update
        # can :destroy, user.permission.models_destroy
        # can :manage, user.permission.models_destroy
      end
  end

  private 
  def set_permission(id)
    Permission.find(id)
  end
end