# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    case user
      when Admin
          can :create, [ Content, Symptom ]
      when Manager
          can :create, Content
      end
  end
end
