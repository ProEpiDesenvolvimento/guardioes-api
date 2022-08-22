require 'rails_helper'

RSpec.describe GroupManagerTeam, type: :model do
  describe 'is_permitted?' do 
    before(:all) do 
      @parent_node = Group.create!(description: 'root_node')
      @app = App.create!(app_name: 'app', owner_country: 'valid_country')
    end

    it 'should return false if self.permission != nil and !self.permission.models_manage.include?(\'group\') == true' do
      group_manager = GroupManager.create!(email: 'valid@email.com', password: 'valid_password', vigilance_syndromes: [])

      group = Group.create!(description: 'valid_description', group_manager_id: group_manager.id, parent_id: @parent_node.id)

      manager_group_permission = ManagerGroupPermission.create!(group_manager_id: group_manager.id, group_id: group.id)

      group_manager_team = GroupManagerTeam.create!(email: 'valid@email.com', password: 'valid_password', group_manager_id: group_manager.id, app_id: @app.id)

      permission = Permission.create!(models_manage: ['test', 'test2'] , group_manager_id: group_manager.id, group_manager_team_id: group_manager_team.id)

      expect(group_manager_team.is_permitted?(group)).to be false 
    end


    it 'should return true if self.permission == nil and self.groups.include? group' do
      group_manager = GroupManager.create!(email: 'valid@email.com', password: 'valid_password', vigilance_syndromes: [])

      group = Group.create!(description: 'valid_description', group_manager_id: group_manager.id, parent_id: @parent_node.id)

      manager_group_permission = ManagerGroupPermission.create!(group_manager_id: group_manager.id, group_id: group.id)

      group_manager_team = GroupManagerTeam.create!(email: 'valid@email.com', password: 'valid_password', group_manager_id: group_manager.id, app_id: @app.id)

      permission = Permission.create!(models_manage: ['group', 'test',], group_manager_id: group_manager.id, group_manager_team_id: group_manager_team.id)      

      expect(group_manager_team.is_permitted?(group)).to be true
    end

    it 'should return false if self.permission == nil' do
      group_manager = GroupManager.create!(email: 'valid@email.com', password: 'valid_password', vigilance_syndromes: [])

      group = Group.create!(description: 'valid_description', group_manager_id: group_manager.id, parent_id: @parent_node.id)

      group_manager_team = GroupManagerTeam.create!(email: 'valid@email.com', password: 'valid_password', group_manager_id: group_manager.id, app_id: @app.id)

      expect(group_manager_team.is_permitted?(group)).to be false 
    end

    it 'should return false if (self.permission == nil or/and !self.permission.models_manage.include?(\'group\') == false) and self.groups.include? group == false' do
      group_manager = GroupManager.create!(email: 'valid@email.com', password: 'valid_password', vigilance_syndromes: [])

      group = Group.create!(description: 'valid_description', group_manager_id: group_manager.id, parent_id: @parent_node.id)

      manager_group_permission = ManagerGroupPermission.create!(group_manager_id: group_manager.id, group_id: group.id)

      group_manager_team = GroupManagerTeam.create!(email: 'valid@email.com', password: 'valid_password', group_manager_id: group_manager.id, app_id: @app.id)

      permission = Permission.create!(models_manage: ['test', 'test2',], group_manager_id: group_manager.id, group_manager_team_id: group_manager_team.id)      

      expect(group_manager_team.is_permitted?(group)).to be false
    end
  end 
end