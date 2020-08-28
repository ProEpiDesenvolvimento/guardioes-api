class AddSelfReferenceToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :parent, index: true
  end
end
