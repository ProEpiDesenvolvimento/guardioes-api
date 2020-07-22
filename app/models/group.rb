class Group < ApplicationRecord
  # The parent node of all the nodes has the description 'root_node'
  # Stucture is as follows:
  #          ----- root_node -----
  #          |                   |
  #   --- child_1 ---    --- child_2 ---
  #   |             |    |             |
  #  ...           ...  ...           ... 

  belongs_to :manager, optional: true, class_name: "Manager"

  belongs_to :parent, class_name: "Group", optional: true
  has_many :children, class_name: "Group", foreign_key: "parent_id"

  # Returns tree structure that leads to current group
  def get_path(string_only = false, labeled = false)
    path = []
    current_node = self
    puts current_node
    while current_node.description != 'root_node'
      if labeled
        if string_only
          path << { group: current_node.description, label: current_node.label }
        else
          path << { group: current_node, label: current_node.label }
        end
      else
        if string_only
          path << current_node.description
        else
          path << current_node
        end
      end
      current_node = current_node.parent
    end
    return path.reverse
  end

  def label
    return parent.children_label
  end

  def destroy
    
  end
end
