require 'rails_helper'

def create_fga_group_tree
  Group::setup
  root = Group::get_root
  brasil = create_group('Brasil', children_label='Estado', parent=root, save=true)
  df = create_group('DF', children_label='Cidade', parent=brasil, save=true)
  gama = create_group('Gama', children_label='Instituição', parent=df, save=true)
  unb = create_group('UnB', children_label='Faculdade', parent=gama, save=true)
  create_group('FGA', nil, parent=unb, save=true)
end

RSpec.describe GroupManager, type: :model do
  describe 'Is group manager permitted?' do 
    context 'Is group manager permitted?' do
      before(:each) do 
        @app = App.create!(app_name: 'app_name', owner_country: 'Brasil')
        @app = @app.reload
        @parent = Group.create!(description: 'root_node')
        @group_manager_1 = GroupManager.create!(email: 'gm1@gm.com', password: "12345678", vigilance_syndromes: [])
        @group_manager_1 = @group_manager_1.reload
        @group_manager_2 = GroupManager.create!(email: 'gm2@gm.com', password: "12345678", vigilance_syndromes: [])
        @group_manager_2 = @group_manager_2.reload
        @g1 = Group.create!(description: 'Brasil', group_manager_id: @group_manager_1.id, parent_id: @parent.id)
        @g2 = Group.create!(description: 'root_node', group_manager_id: @group_manager_2.id, parent_id: @parent.id)
        @manager_group_permission = ManagerGroupPermission.create!(group_manager_id: @group_manager_1.id, group_id: @g1.id)
        @group_manager_team1 = GroupManagerTeam.create!(email: 'gm1@gm.com', password: '12345678', group_manager_id: @group_manager_1.id, app_id: @app.id)
        @group_manager_team1 = @group_manager_team1.reload
        @group_manager_team2 = GroupManagerTeam.create!(email: 'gm2@gm.com', password: '12345678', group_manager_id: @group_manager_2.id, app_id: @app.id)
        @group_manager_team2 = @group_manager_team2.reload
        @permission = Permission.create!(models_manage: ['message', 'form'], group_manager_id: @group_manager_1.id, group_manager_team_id: @group_manager_team1.id)
      end

      it 'Permissão válida' do
        expect(@group_manager_1.is_permitted?(@g1)).to be true 
      end

      it 'Group.description inválida' do
        expect(@group_manager_2.is_permitted?(@g2)).to be false
      end 
    end
  end

  context 'form_id' do
    it 'has id' do
      fga = create_fga_group_tree
      gm = create_group_manager(twitter=nil, form_id='123', save=true)
      connect_group_to_group_manager(fga, gm)
      expect(form_id).to eq('123')
    end
    it 'does not have id' do
      fga = create_fga_group_tree
      expect(fga.form_id).to eq(nil)
    end
  end
end