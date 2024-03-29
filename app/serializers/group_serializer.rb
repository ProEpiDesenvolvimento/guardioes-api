class GroupSerializer < ActiveModel::Serializer
  attributes :id, :description, :children_label, :parent, :require_id, :id_code_length,
             :form_id, :code, :address, :cep, :phone, :email,
             :created_by, :updated_by

  belongs_to :group_manager

  def parent
    if object.parent == nil
      return nil
    end
    { name: object.parent.description, id: object.parent.id, children_label: object.parent.children_label }
  end

  def require_id
    object.require_id
  end

  def id_code_length
    object.id_code_length
  end

  def form_id
    object.form_id
  end
end
