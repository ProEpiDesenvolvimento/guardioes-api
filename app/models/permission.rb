class Permission < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :manager, optional: true
  belongs_to :city_manager, optional: true
  belongs_to :group_manager, optional: true

  serialize :models_create, Array 
  serialize :models_read, Array
  serialize :models_update, Array
  serialize :models_destroy, Array
  serialize :models_manage, Array
end
