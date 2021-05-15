class Group < ApplicationRecord
  # FOR PROPER FUNCTIONING OF THIS MODEL, THERE MUST EXIST A GROUP CALLED 'root_node'
  # root_node is the parent group of all the groups, can be easily created by typing

  # -----------------------> Group::setup() in rails console <-----------------------
  
  # Stucture is as follows:
  #          ----- root_node -----
  #          |                   |
  #   --- child_1 ---    --- child_2 ---
  #   |             |    |             |
  #  ...           ...  ...           ...
  # root node has many children, all of them are countries
  # all of those have children, each of them states in the country
  # all of those have children, each of them are municipalities in a state
  # children of municipalities must be a institution (for example, UnB) 

  # Each group has [0..n] managers
  has_many :manager_group_permission, :class_name => 'ManagerGroupPermission'
  has_many :group_managers, :through => :manager_group_permission 

  # Each group has one parent (except for 'root_node', that's why optional is true)
  belongs_to :parent, class_name: "Group", optional: true
  # Each group has [0..n] children groups
  has_many :children, class_name: "Group", foreign_key: "parent_id"

  belongs_to :group_manager, optional: true

  # Call this function to initialize groups model inner workings
  def self.setup
    group = Group.new(description: 'root_node', children_label: 'Pais')
    group.save()
    return group
  end

  # Return parent group
  def self.get_root
    group = Group.find_by_description('root_node')
    group = Group::setup() if group.nil?
    return group
  end

  # Returns tree structure that leads to current group
  def get_path(string_only = false, labeled = false)
    path = []
    current_node = self
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

  # Recursively looks for a twitter handle that is not nil
  # If none is found, returns app's standard twitter
  def get_twitter
    current_node = self
    twitter = "appguardioes"
    loop do
      if current_node.group_manager != nil
        if current_node.group_manager.twitter != nil
          twitter = current_node.group_manager.twitter
          break
        end
      end
      break if current_node.parent.nil?
      current_node = current_node.parent
    end
    return twitter
  end

  # Returns the label for a given group
  # For example: label for group New York would be 'City'
  def label
    return parent.children_label
  end

  # Deletes current group and all of it's subtree
  # If you delete New York subtree expect every child, grandchild and so on to be deleted too
  def delete_subtree
    children.each do |child|
      child.delete_subtree
    end
    User.where(group_id:id).each do |u|
      u.update_attribute(:group_id, nil)
    end
    manager_group_permission.each do |m|
      m.delete
    end
    delete
  end

  def require_id
    if group_manager != nil
      if group_manager.require_id != nil
        return group_manager.require_id
      end
    end
    return false
  end

  def id_code_length
    if group_manager != nil
      if group_manager.id_code_length != nil
        return group_manager.id_code_length
      end
    end
    return nil
  end

  def form_id
    if group_manager != nil
      if group_manager.form != nil
        return group_manager.form.id
      end
    end
    return nil
  end
end
