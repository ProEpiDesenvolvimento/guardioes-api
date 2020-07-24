class ManagerGroupPermission < ApplicationRecord
  belongs_to :manager
  belongs_to :group

  def self.permit(manager, group)
    raise RuntimeError, 'Nil manager' if manager.nil?
    raise RuntimeError, 'Nil group' if group.nil?
    ManagerGroupPermission.new(
      manager: manager,
      group: group
    ).save()
  end
end
