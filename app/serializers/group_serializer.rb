class GroupSerializer < ActiveModel::Serializer
  attributes :id, :description, :children_label, :parent,
             :group_manager, :form_id, :code, :address, :cep, :phone, :email

  def parent
    if object.parent == nil
      return nil
    end
    { name: object.parent.description, id: object.parent.id, children_label: object.parent.children_label }
  end

  def form_id
    object.form_id
  end
end
