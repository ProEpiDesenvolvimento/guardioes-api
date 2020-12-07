# frozen_string_literal: true

class ManagerGroupPermission < ApplicationRecord
  belongs_to :group_manager
  belongs_to :group

  def self.permit(group_manager, group)
    raise 'Nil group manager' if group_manager.nil?
    raise 'Nil group' if group.nil?

    ManagerGroupPermission.new(
      group_manager: group_manager,
      group: group
    ).save
  end

  def self.unpermit(group_manager, group)
    raise 'Nil group manager' if group_manager.nil?
    raise 'Nil group' if group.nil?

    ManagerGroupPermission.where(group_manager: group_manager, group: group).each(&:delete)
  end
end
