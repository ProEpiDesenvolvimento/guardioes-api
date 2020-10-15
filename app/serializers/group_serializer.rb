class GroupSerializer < ActiveModel::Serializer
  attributes :id, :description, :children_label, :parent, :require_id, :id_code_length,
             :group_manager, :code, :address, :cep, :phone, :email

  def parent
    if object.parent == nil
      return nil
    end
    { name: object.parent.description, id: object.parent.id }
  end

  def require_id
    object.require_id
  end

  def id_code_length
    object.id_code_length
  end
end
